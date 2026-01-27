{config, ...}: let
  vars = import ./variables.nix;
  domainName = vars.domain.name;
in {
  virtualisation.oci-containers.containers.plex = {
    image = "plexinc/pms-docker:plexpass";
    autoStart = true;

    environment = {
      ALLOWED_NETWORKS = "172.16.0.0/24,172.16.10.0/24,172.16.20.0/24";
      HOSTNAME = "SPICE MEDIA SERVER";
      PUID = vars.user.uid;
      PGID = vars.user.pid;
      TZ = vars.user.tz;
      VERSION = "docker";
      PLEX_CLAIM = "/run/secrets/plex-claim";
      ADVERTISE_IP = "http://${vars.system.localhost}:32400,https://watch.${vars.domain.name}";
    };

    volumes = [
      #"${vars.system.dockerDir}/plex/plexms:/config"
      "${vars.system.mediaDir}/plexms:/config"
      "${vars.system.mediaDir}/4k:/plex_4k"
      "${vars.system.mediaDir}/movies:/plex_movies"
      "${vars.system.mediaDir}/tv_shows:/plex_tv"
      "${vars.system.mediaDir}/plex_tmp:/transcode"
    ];

    ports = [
      "32400:32400"
      "3005:3005"
      "8324:8324"
      "32469:32469"
      "1900:1900/udp"
      "32410:32410/udp"
      "32412:32412/udp"
      "32413:32413/udp"
      "32414:32414/udp"
    ];

    networks = [
      "t2_proxy"
    ];

    extraOptions = [
      "--no-healthcheck"
    ];

    labels = {
      "traefik.enable" = "true";
      ## HTTP Routers
      "traefik.http.routers.plex-rtr.entrypoints" = "https";
      "traefik.http.routers.plex-rtr.rule" = "Host(`watch.${domainName}`)";
      "traefik.http.routers.plex-rtr.tls" = "true";
      ## HTTP Services
      "traefik.http.routers.plex-rtr.middlewares" = "chain-no-auth@file"; # (Authelia Auth)
      "traefik.http.routers.plex-rtr.service" = "plex-svc";
      "traefik.http.services.plex-svc.loadbalancer.server.port" = "32400";

      #"traefik.docker.network" = "t2_proxy";
    };

    log-driver = vars.common.logDriver;
  };
}
