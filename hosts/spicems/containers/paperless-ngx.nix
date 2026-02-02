{
  config,
  lib,
  pkgs,
  ...
}: let
  vars = import ./variables.nix;
  dataDir = "/home/alex/docker/paperless-ngx/data";
  mediaDir = "/thufir2/paperless/documents"; # From your previous config
  domainName = vars.domain.name;

  consumeDir = "/thufir2/paperless/import";
  exportDir = "/thufir2/paperless/export";
  pgdataDir = "/var/lib/paperless";
  redisdataDir = "/home/alex/docker/paperless-ngx/redis";

  # Network for internal communication
  networkName = "t2_proxy";
in {
  virtualisation.oci-containers = {
    containers = {
      paperless-broker = {
        image = "redis:8";
        autoStart = true;
        volumes = [
          "${redisdataDir}:/data"
        ];
        networks = [networkName];
      };

      paperless-db = {
        image = "postgres:18";
        autoStart = true;
        volumes = [
          "${pgdataDir}:/var/lib/postgresql" # Assuming standard Postgres data path
        ];
        environment = {
          POSTGRES_DB = "paperless";
          POSTGRES_USER = "paperless";
          POSTGRES_PASSWORD = "/run/secrets/paperless/postgres-password"; # Change this to a secret
        };
        networks = [networkName];
      };

      paperless-gotenberg = {
        image = "gotenberg/gotenberg:8.25";
        autoStart = true;
        cmd = [
          "gotenberg"
          "--chromium-disable-javascript=true"
          "--chromium-allow-list=file:///tmp/.*"
        ];
        networks = [networkName];
      };

      paperless-tika = {
        image = "apache/tika:latest";
        autoStart = true;
        networks = [networkName];
      };

      paperless-webserver = {
        image = "ghcr.io/paperless-ngx/paperless-ngx:latest";
        autoStart = true;
        dependsOn = [
          "paperless-db"
          "paperless-broker"
          "paperless-gotenberg"
          "paperless-tika"
        ];
        ports = [
          "8000:8000"
        ];
        volumes = [
          "${dataDir}:/usr/src/paperless/data"
          "${mediaDir}:/usr/src/paperless/media"
          "${exportDir}:/usr/src/paperless/export"
          "${consumeDir}:/usr/src/paperless/consume"
        ];
        environment = {
          PAPERLESS_REDIS = "redis://paperless-broker:6379";
          PAPERLESS_DBHOST = "paperless-db";
          PAPERLESS_TIKA_ENABLED = "1";
          PAPERLESS_TIKA_GOTENBERG_ENDPOINT = "http://paperless-gotenberg:3000";
          PAPERLESS_TIKA_ENDPOINT = "http://paperless-tika:9998";
          PAPERLESS_URL = "https://paperless.${domainName}";
          PAPERLESS_CSRF_TRUSTED_ORIGINS = "https://paperless.${domainName}";
          PAPERLESS_CORS_ALLOWED_HOSTS = "https://paperless.${domainName}";
        };
        networks = [networkName];

        labels = {
          "traefik.enable" = "true";
          # HTTP Routers
          "traefik.http.routers.paperless-rtr.entrypoints" = "https";
          "traefik.http.routers.paperless-rtr.tls" = "true";
          "traefik.http.routers.paperless-rtr.rule" = "Host(`paperless.${domainName}`)";
          # Middlewares
          "traefik.http.routers.paperless-rtr.middlewares" = "chain-authelia@file"; # (Authelia Auth)
          # HTTP Services
          "traefik.http.routers.paperless-rtr.service" = "paperless-svc";
          "traefik.http.services.paperless-svc.loadbalancer.server.port" = "8000";
        };
      };
    };
  };

  # Optional: Add systemd dependencies if startup order issues arise
  # For example:
  systemd.services."podman-paperless-webserver" = {
    after = ["podman-paperless-db.service" "podman-paperless-broker.service"];
    requires = ["podman-paperless-db.service" "podman-paperless-broker.service"];
  };

  # Ensure directories exist (NixOS will handle via activation if needed, or use systemd.tmpfiles)
  # Add firewall opening if enabled
  # networking.firewall.allowedTCPPorts = [8000];

  # If using Traefik like in radarr.nix, add labels to paperless-webserver
  # For example:
  # labels = { ... traefik config ... };
}
