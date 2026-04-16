{config, ...}: let
  vars = import ./variables.nix;
  dockerDir = vars.system.dockerDir;
  arrayDir = vars.system.arrayDir;
  domainName = vars.domain.name;
  immichVersion = vars.immich.version;
  uploadLocation = vars.immich.uploadLocation;
  dbDataLocation = vars.immich.dbDataLocation;
in {
  virtualisation.oci-containers.containers = {
    immich-server = {
      autoStart = true;
      image = "ghcr.io/immich-app/immich-server:${immichVersion}";

      volumes = [
        "${uploadLocation}:/data"
        "${config.sops.secrets."immich/postgres-user".path}:/run/secrets/immich/postgres-user:ro"
        "${config.sops.secrets."immich/postgres-password".path}:/run/secrets/immich/postgres-password:ro"
        "${config.sops.secrets."immich/postgres-db".path}:/run/secrets/immich/postgres-db:ro" # if you add it
      ];

      ports = [
        "2283:2283"
      ];

      dependsOn = [
        "immich-redis"
        "immich-database"
      ];

      environment = {
        DB_HOSTNAME = "immich-database";
        REDIS_HOSTNAME = "immich-redis";
        DB_PASSWORD_FILE = "/run/secrets/immich/postgres-password";
        DB_USERNAME_FILE = "/run/secrets/immich/postgres-user";
        DB_DATABASE_NAME_FILE = "/run/secrets/immich/postgres-db";
      };

      networks = [
        "t2_proxy"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.immich-rtr.entrypoints" = "https";
        "traefik.http.routers.immich-rtr.rule" = "Host(`immich.${domainName}`)";
        "traefik.http.routers.immich-rtr.tls" = "true";
        "traefik.http.routers.immich-rtr.service" = "immich-svc";
        "traefik.http.services.immich-svc.loadbalancer.server.port" = "2283";
        "traefik.http.routers.immich-rtr.middlewares" = "chain-no-auth@file";
      };
    };

    immich-machine-learning = {
      autoStart = true;
      image = "ghcr.io/immich-app/immich-machine-learning:${immichVersion}";

      volumes = [
        "model-cache:/cache"
        "${config.sops.secrets."immich/postgres-user".path}:/run/secrets/immich/postgres-user:ro"
        "${config.sops.secrets."immich/postgres-password".path}:/run/secrets/immich/postgres-password:ro"
        "${config.sops.secrets."immich/postgres-db".path}:/run/secrets/immich/postgres-db:ro" # if you add it
      ];

      environment = {
        DB_PASSWORD_FILE = "/run/secrets/immich/postgres-password";
        DB_USERNAME_FILE = "/run/secrets/immich/postgres-user";
        DB_DATABASE_NAME_FILE = "/run/secrets/immich/postgres-db";
      };

      networks = [
        "t2_proxy"
      ];
    };

    immich-redis = {
      autoStart = true;
      image = "docker.io/valkey/valkey:9@sha256:3eeb09785cd61ec8e3be35f8804c8892080f3ca21934d628abc24ee4ed1698f6";

      networks = [
        "t2_proxy"
      ];

      ## Healtcheck here
    };

    immich-database = {
      autoStart = true;
      image = "ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0@sha256:bcf63357191b76a916ae5eb93464d65c07511da41e3bf7a8416db519b40b1c23";

      environment = {
        POSTGRES_PASSWORD_FILE = "/run/secrets/immich/postgres-password";
        POSTGRES_USER_FILE = "/run/secrets/immich/postgres-user";
        POSTGRES_DB_FILE = "/run/secrets/immich/postgres-db";
        POSTGRES_INITDB_ARGS = "--data-checksums";
      };

      volumes = [
        "${dbDataLocation}:/var/lib/postgresql/data"
        "${config.sops.secrets."immich/postgres-user".path}:/run/secrets/immich/postgres-user:ro"
        "${config.sops.secrets."immich/postgres-password".path}:/run/secrets/immich/postgres-password:ro"
        "${config.sops.secrets."immich/postgres-db".path}:/run/secrets/immich/postgres-db:ro" # if you add it
      ];

      networks = [
        "t2_proxy"
      ];
      #      shm_size = ["128mb"]; # Does not exist
    };
  };
}
