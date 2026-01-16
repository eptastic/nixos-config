#    networks:
#      - t2_proxy
#    labels:
#      - "traefik.enable=true"
#      - "traefik.http.routers.overseerr-rtr.entrypoints=https"
#      - "traefik.http.routers.overseerr-rtr.rule=Host(`request.$DOMAINNAME`)"
#      - "traefik.http.routers.overseerr-rtr.tls=true"
#      - "traefik.http.routers.overseerr-rtr.service=overseerr-svc"
#      - "traefik.http.services.overseerr-svc.loadbalancer.server.port=3579"
#      - "traefik.http.routers.overseerr-rtr.middlewares=chain-authelia@file"
{config, ...}: let
  vars = import ./variables.nix;
in {
  virtualisation.oci-containers.containers = {
    seerr = {
      image = "ghcr.io/fallenbagel/jellyseerr:latest";
      autoStart = true;

      environment = {
        LOG_LEVEL = "debug";
        PUID = vars.user.uid;
        PGID = vars.user.pid;
        TZ = vars.user.tz;
      };

      volumes = [
        "${vars.system.dockerDir}/seerr:/config"
      ];

      ports = [
        "5055:5055"
      ];

      log-driver = vars.common.logDriver;
    };
  };
}
