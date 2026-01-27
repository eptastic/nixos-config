{config, ...}: let
  vars = import ./variables.nix;
  domainName = vars.domain.name;
  dockerDir = vars.system.dockerDir;
  puid = vars.user.uid;
  pgid = vars.user.pid;
  tz = vars.user.tz;
in {
  virtualisation.oci-containers.containers.grafana = {
    image = "grafana/grafana:latest";
    autoStart = true;

    ports = [
      "3000:3000"
    ];

    networks = [
      "t2_proxy"
    ];

    volumes = [
      "${dockerDir}/grafana/data:/var/lib/grafana"
      "${dockerDir}/grafana:/etc/grafana"
    ];

    environment = {
      PUID = puid;
      PGID = pgid;
      TZ = tz;
      GF_SERVER_ROOT_URL = "https://grafana.${domainName}";
      GF_SERVER_DOMAIN = "grafana.${domainName}";
    };

    labels = {
      "traefik.enable" = "true";
      #       HTTP Routers
      "traefik.http.routers.grafana-rtr.entrypoints" = "https";
      "traefik.http.routers.grafana-rtr.tls" = "true";
      "traefik.http.routers.grafana-rtr.rule" = "Host(`grafana.${domainName}`)";
      # Middlewares
      "traefik.http.routers.grafana-rtr.middlewares" = "chain-authelia@file"; # (Authelia Auth)
      # HTTP Services
      "traefik.http.routers.grafana-rtr.service" = "grafana-svc";
      "traefik.http.services.grafana-svc.loadbalancer.server.port" = "3000";
    };
  };
}
