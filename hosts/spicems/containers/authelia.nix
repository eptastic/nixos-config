{config, ...}: let
  vars = import ./variables.nix;
  domainName = vars.domain.name;
in {
  virtualisation.oci-containers.containers = {
    authelia = {
      image = "authelia/authelia:latest";
      autoStart = true;
      #dependsOn = ["mariadb"];

      environment = {
        ## Need to change this back to Alex user (1000). So secrets need to be accesible by that user
        PUID = "0";
        PGID = "0";

        AUTHELIA_IDENTITY_VALIDATION_RESET_PASSWORD_JWT_SECRET_FILE = "/run/secrets/authelia/jwt";
        AUTHELIA_SESSION_SECRET_FILE = "/run/secrets/authelia/session-file";
        AUTHELIA_STORAGE_ENCRYPTION_KEY_FILE = "/run/secrets/authelia/storage-encrypt";
        AUTHELIA_DUO_API_SECRET_KEY_FILE = "/run/secrets/authelia/duo";
        AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE = "/run/secrets/authelia/smtp-password";
      };

      volumes = [
        "${vars.system.dockerDir}/authelia:/config"
        "/run/secrets:/run/secrets:ro"
      ];

      networks = [
        "t2_proxy"
      ];

      ports = [
        "9091:9091"
      ];

      labels = {
        "traefik.enable" = "true";
        ## HTTP Routers
        "traefik.http.routers.authelia-rtr.entrypoints" = "https";
        "traefik.http.routers.authelia-rtr.tls" = "true";
        "traefik.http.routers.authelia-rtr.rule" = "Host(`auth.${domainName}`)";
        #- "traefik.http.routers.authelia.tls.certresolver=cloudflare"
        ## Middlewares
        "traefik.http.routers.authelia-rtr.middlewares" = "chain-no-auth@file";
        ## HTTP Services
        "traefik.http.routers.authelia-rtr.service" = "authelia-svc";
        "traefik.http.services.authelia-svc.loadbalancer.server.port" = "9091";
        #- "traefik.http.middlewares.authelia.forwardauth.address=http://authelia:9090/api/authz/forward-auth?authelia_url=https://authelia.spice.cx"  # yamllint disable-line rule:line-length"
        #- "traefik.http.middlewares.authelia.forwardauth.trustForwardHeader=true"
        #- "traefik.http.middlewares.authelia.forwardauth.authResponseHeaders=Remote-User,Remote-Groups,Remote-Name,Remote-Email"  # yamllint disable-line rule:line-length
      };
    };
  };
  ## Not necessary to have mariadb since I'm using sql lite
  #    mariadb = {
  #      image = "mariadb:latest";
  #      autoStart = true;
  #
  #      environment = {
  #        PUID = vars.user.uid;
  #        PGID = vars.user.pid;
  #        TZ = vars.user.tz;
  #
  #        MYSQL_ROOT_PASSWORD = config.sops.secrets."authelia/mariadb/root-pass".path;
  #        MYSQL_DATABASE = config.sops.secrets."authelia/mariadb/database".path;
  #        MYSQL_USER = config.sops.secrets."authelia/mariadb/user".path;
  #      };
  #
  #      volumes = [
  #        "${vars.system.dockerDir}/mariadb:/var/lib/mysql"
  #        "${vars.system.dockerDir}/mariadb:/config"
  #      ];
  #
  #      ports = [
  #        "3306:3306"
  #      ];
  #
  #      networks = [
  #        "t2_proxy"
  #      ];
  #    };
  #  };
}
