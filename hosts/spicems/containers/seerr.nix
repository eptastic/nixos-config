{config, ...}: let
  vars = import ./variables.nix;
  domainName = vars.domain.name;
  dockerDir = vars.system.dockerDir;
  userUid = vars.user.uid;
  userPid = vars.user.pid;
  tz = vars.user.tz;
  logDriver = vars.common.logDriver;
in {
  virtualisation.oci-containers.containers = {
    seerr = {
      image = "ghcr.io/fallenbagel/jellyseerr:latest";
      autoStart = true;

      environment = {
        LOG_LEVEL = "debug";
        PUID = userUid;
        PGID = userPid;
        TZ = tz;
      };

      volumes = [
        "${dockerDir}/seerr:/app/config"
      ];

      ports = [
        "5055:5055"
      ];

      log-driver = logDriver;

      networks = [
        "t2_proxy"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.seerr-rtr.entrypoints" = "https";
        "traefik.http.routers.seerr-rtr.rule" = "Host(`request.${domainName}`)";
        "traefik.http.routers.seerr-rtr.tls" = "true";
        "traefik.http.routers.seerr-rtr.service" = "seerr-svc";
        "traefik.http.services.seerr-svc.loadbalancer.server.port" = "5055";
        "traefik.http.routers.seerr-rtr.middlewares" = "chain-authelia@file";
      };
    };
  };
}
