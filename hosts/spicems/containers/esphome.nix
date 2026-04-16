{
  config,
  pkgs,
  ...
}: let
  vars = import ./variables.nix;
  domainName = vars.domain.name;
  dockerDir = vars.system.dockerDir;
  localhost = vars.system.localhost;
  tz = vars.user.tz;
in {
  virtualisation.oci-containers.containers = {
    esphome = {
      image = "ghcr.io/esphome/esphome";
      autoStart = true;

      ports = ["6052:6052"];

      volumes = [
        "${dockerDir}/esphome:/config:rw"
        "/etc/localtime:/etc/localtime:ro"
      ];

      networks = [
        "t2_proxy"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.esphome-rtr.entrypoints" = "https";
        "traefik.http.routers.esphome-rtr.rule" = "Host(`esphome.${domainName}`)";
        "traefik.http.routers.esphome-rtr.tls" = "true";
        "traefik.http.routers.esphome-rtr.service" = "esphome-svc";
        "traefik.http.services.esphome-svc.loadbalancer.server.port" = "6052";
        "traefik.http.routers.esphome-rtr.middlewares" = "chain-authelia@file";
      };
    };
  };
}
