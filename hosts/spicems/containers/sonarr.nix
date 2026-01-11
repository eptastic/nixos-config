#    networks:
#      - t2_proxy
#    labels:
#      - "traefik.enable=true"
#      - "traefik.http.routers.radarr-rtr.entrypoints=https"
#      - "traefik.http.routers.radarr-rtr.rule=Host(`radarr.$DOMAINNAME`)"
#      - "traefik.http.routers.radarr-rtr.tls=true"
#      - "traefik.http.routers.radarr-rtr.service=radarr-svc"
#      - "traefik.http.services.radarr-svc.loadbalancer.server.port=7878"
#      - "traefik.http.routers.radarr-rtr.middlewares=chain-authelia@file"
#        #
{config, ...}: let
  vars = import ./variables.nix;
in {
  virtualisation.oci-containers.containers.sonarr = {
    image = "linuxserver/sonarr:latest";
    autoStart = true;

    environment = {
      PUID = vars.user.uid;
      PGID = vars.user.pid;
      TZ = vars.user.tz;
    };

    volumes = [
      "${vars.system.dockerDir}/sonarr:/config"
      "${vars.system.sabDir}/complete:/downloads"
      "${vars.system.mediaDir}/tv_shows:/tv_shows"
      "${vars.system.dockerDir}/shared:/shared"
      "${vars.system.arrayDir}/recycling_bin:/recycling_bin"
      "/etc/localtime:/etc/localtime:ro"
    ];

    ports = [
      "8989:8989"
    ];

    log-driver = vars.common.logDriver;
  };
}
