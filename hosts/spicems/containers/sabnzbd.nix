{config, ...}: let
  vars = import ./variables.nix;
  domainName = vars.domain.name;
in {
  virtualisation.oci-containers.containers = {
    sabnzbd = {
      image = "linuxserver/sabnzbd:latest";
      autoStart = true;

      environment = {
        PUID = vars.user.uid;
        PGID = vars.user.pid;
        TZ = vars.user.tz;
      };

      volumes = [
        "${vars.system.dockerDir}/sabnzbd:/config"
        "${vars.system.sabDir}/complete:/downloads"
        "${vars.system.sabDir}/incomplete:/incomplete-downloads"
        "${vars.system.sabDir}/incomplete:/alt-incomplete-downloads"
        "${vars.system.sabDir}/shared:/shared"
      ];

      ports = [
        "8081:8080"
      ];

      log-driver = vars.common.logDriver;

      networks = [
        "t2_proxy"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.sab-rtr.entrypoints" = "https";
        "traefik.http.routers.sab-rtr.rule" = "Host(`sab.${domainName}`)";
        "traefik.http.routers.sab-rtr.tls" = "true";
        "traefik.http.routers.sab-rtr.service" = "sab-svc";
        "traefik.http.services.sab-svc.loadbalancer.server.port" = "8080";
        "traefik.http.routers.sab-rtr.middlewares" = "chain-authelia@file";
      };
    };
  };
}
