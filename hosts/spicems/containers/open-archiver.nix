{
  config,
  pkgs,
  lib,
  ...
}: let
  storage = {
    root = "/thufir2/mail_archive";
    postgres = "/home/alex/docker/open-archiver/postgres";
    valkey = "/home/alex/docker/open-archiver/valkey";
    meili = "/home/alex/docker/open-archiver/meili";
  };

  # Shorter aliases – adjust prefix if your sops keys are nested differently
  s = config.sops.secrets;
in {
  systemd.tmpfiles.rules = [
    "d /var/lib/open-archiver           0755 root root - -"
    "d ${storage.root}      0755 root root - -"
    "d ${storage.postgres}  0750 root root - -"
    "d ${storage.valkey}    0750 root root - -"
    "d ${storage.meili}     0750 root root - -"
  ];

  virtualisation.oci-containers.containers = {
    open-archiver = {
      image = "logiclabshq/open-archiver:latest";
      autoStart = true;

      ports = ["127.0.0.1:3001:3000"];

      environment = {
        STORAGE_LOCAL_ROOT_PATH = storage.root;

        # Database connection – many apps accept postgres:// URI
        DATABASE_URL = "postgresql://${s."open-archiver/postgres-user" or "admin"}:${builtins.readFile s."open-archiver/postgres-password".path}@postgres:5432/open_archive";

        # If the app supports REDIS_URL / CACHE_URL etc.
        REDIS_URL = "redis://default@valkey:6379/0"; # password via _FILE below

        MEILI_HOST = "http://meilisearch:7700";
        TIKA_SERVER_ENDPOINT = "http://tika:9998";

        # → Add any other non-secret env vars your app needs
      };

      # ────────────────────────────────────────────────
      # Secrets via _FILE (recommended pattern)
      # ────────────────────────────────────────────────
      environmentFiles = []; # ← no plain .env needed anymore

      # The important part: bind-mount each secret file
      volumes = [
        "${storage.root}:${storage.root}"

        # Secrets – read-only bind mounts
        "${s."open-archiver/postgres_password".path}:/run/secrets/open-archiver/postgres-password:ro"
        "${s."open-archiver/valkey_password".path}:/run/secrets/open-archiver/valkey:ro"
        "${s."open-archiver/meili_master_key".path}:/run/secrets/open-archiver/meili-master-key:ro"

        # Add more if needed, e.g.
        # "${s."open-archiver/jwt_secret".path}:/run/secrets/open-archiver/jwt_secret:ro"
      ];

      # Now tell the app where to read each secret from
      environment = {
        # PostgreSQL (if it supports _FILE – many drivers/libs do)
        POSTGRES_PASSWORD_FILE = "/run/secrets/open-archiver/postgres-password";

        # Valkey / Redis
        REDIS_PASSWORD_FILE = "/run/secrets/open-archiver/valkey";
        # or VALKEY_PASSWORD_FILE / CACHE_PASSWORD_FILE – check your app's docs

        # Meilisearch
        MEILI_MASTER_KEY_FILE = "/run/secrets/open-archiver/meili-master-key";

        # Add others according to what open-archiver actually reads
      };

      dependsOn = ["postgres" "valkey" "meilisearch"];

      extraOptions = [
        "--network=open-archiver-net"
        "--restart=unless-stopped"
      ];
    };

    postgres = {
      image = "postgres:17-alpine";
      autoStart = true;

      environment = {
        POSTGRES_DB = "open_archive";
        POSTGRES_USER = "admin"; # ← or make configurable
        POSTGRES_PASSWORD_FILE = "/run/secrets/open-archiver/postgres-password";
      };

      volumes = [
        "${s."open-archiver/postgres-password".path}:/run/secrets/open-archiver/postgres-password:ro"
        "${storage.postgres}:/var/lib/postgresql/data"
      ];

      extraOptions = ["--network=open-archiver-net" "--restart=unless-stopped"];
    };

    valkey = {
      image = "valkey/valkey:8-alpine";
      autoStart = true;

      cmd = [
        "valkey-server"
        "--requirepass"
        "FILE:/run/secrets/opena-rchiver/valkey" # Valkey 8+ supports this syntax
        # or use a tiny entrypoint wrapper if needed
      ];

      volumes = [
        "${s."open-archiver/valkey".path}:/run/secrets/open-archiver/valkey:ro"
        "${storage.valkey}:/data"
      ];

      extraOptions = ["--network=open-archiver-net" "--restart=unless-stopped"];
    };

    meilisearch = {
      image = "getmeili/meilisearch:v1.15";
      autoStart = true;

      environment = {
        MEILI_MASTER_KEY_FILE = "/run/secrets/open-archiver/meili-master-key";
      };

      volumes = [
        "${s."open-archiver/meili-master-key".path}:/run/secrets/open-archiver/meili-master-key:ro"
        "${storage.meili}:/meili_data"
      ];

      extraOptions = ["--network=open-archiver-net" "--restart=unless-stopped"];
    };

    tika = {
      image = "apache/tika:3.2.2.0-full";
      autoStart = true;

      extraOptions = ["--network=open-archiver-net" "--restart=always"];
    };
  };

  # Optional helper aliases
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "oa-logs" "podman logs -f open-archiver")
  ];
}
