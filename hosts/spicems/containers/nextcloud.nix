{
  pkgs,
  lib,
  config,
  ...
}: let
  vars = import ./variables.nix;
  mediaDir = vars.system.mediaDir;
  dockerDir = vars.system.dockerDir;
  nextcloudDomain = vars.domain.nextcloud;
  domainName = vars.domain.name;
  nextcloudUser = vars.nextcloud.user;
  nextcloudDb = vars.nextcloud.database;
in {
  virtualisation.oci-containers.containers = {
    nextcloud = {
      image = "nextcloud:stable";
      autoStart = true;
      dependsOn = ["nc-db" "nc-redis"];

      volumes = [
        "${mediaDir}/nextcloud/:/var/www/html"
      ];

      networks = [
        "t2_proxy"
        "nextcloud"
      ];

      environment = {
        REDIS_HOST = "nc-redis";
        NEXTCLOUD_TRUSTED_DOMAIN = "${nextcloudDomain}";
        TRUSTED_PROXIES = "172.16.0.0/16";
      };

      ports = [
        "8079:80"
      ];

      labels = {
        "traefik.enable" = "true";
        ## HTTP Routers
        "traefik.http.routers.nextcloud.entrypoints" = "https";
        "traefik.http.routers.nextcloud.rule" = "Host(`cloud.${domainName}`)";
        "traefik.http.routers.nextcloud.tls" = "true";
        "traefik.http.routers.nextcloud.middlewares" = "chain-nextcloud@file"; # nextcloud chain
        ## HTTP Services
        "traefik.http.routers.nextcloud.service" = "nextcloud";
        "traefik.http.services.nextcloud.loadbalancer.server.port" = "80";
        ## Change below to quotes ##
        "traefik.http.middlewares.nextcloud.headers.customFrameOptionsValue" = "ALLOW-FROM https://cloud.${domainName}";
        "traefik.http.middlewares.nextcloud.headers.contentSecurityPolicy" = "frame-ancestors 'self' cloud. ${domainName}*.cloud.${domainName}";
        "traefik.http.middlewares.nextcloud.headers.stsSeconds" = "155520011";
        "traefik.http.middlewares.nextcloud.headers.stsIncludeSubdomains" = "true";
        "traefik.http.middlewares.nextcloud.headers.stsPreload" = "true";
        "traefik.http.middlewares.nextcloud.headers.customresponseheaders.X-Frame-Options" = "SAMEORIGIN";
        "traefik.http.middlewares.nextcloud_redirect.redirectregex.permanent" = "true";
        "traefik.http.middlewares.nextcloud_redirect.redirectregex.regex" = "https://(.*)/.well-known/(card|cal)dav";
        "traefik.http.middlewares.nextcloud_redirect.redirectregex.replacement" = "https://$${1}/remote.php/dav/";
      };
    };

    nc-db = {
      image = "mariadb:11.4";
      autoStart = true;

      volumes = [
        "${dockerDir}/nc-db:/var/lib/mysql"
      ];

      networks = [
        "nextcloud"
      ];

      ports = [
        "3307:3306"
      ];

      environment = {
        MYSQL_USER = "${nextcloudUser}";
        MYSQL_DATABASE = "${nextcloudDb}";
        MYSQL_PASSWORD = "run/secrets/nc/mysql-password";
        MYSQL_ROOT_PASSWORD = "/run/secrets/nc/mysql-root-password";
      };
    };

    nc-redis = {
      image = "redis:6.2-alpine";
      autoStart = true;

      volumes = [
        "${dockerDir}/nextcloud-redis:/data"
      ];

      networks = [
        "nextcloud"
      ];
    };
  };
}
#command: --transaction-isolation=READ-COMMITED --log-bin=mysqld-bin --binlog-format=ROW

