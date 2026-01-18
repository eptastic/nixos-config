{config, ...}: let
  vars = import ./variables.nix;
  domainName = vars.domain.name;
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

    networks = [
      "t2_proxy"
    ];

    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.sonarr-rtr.entrypoints" = "https";
      "traefik.http.routers.sonarr-rtr.rule" = "Host(`sonarr.${domainName}`)";
      "traefik.http.routers.sonarr-rtr.tls" = "true";
      "traefik.http.routers.sonarr-rtr.service" = "sonarr-svc";
      "traefik.http.services.sonarr-svc.loadbalancer.server.port" = "8989";
      "traefik.http.routers.sonarr-rtr.middlewares" = "chain-authelia@file";
    };
  };
}
