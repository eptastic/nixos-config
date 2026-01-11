{
  pkgs,
  lib,
  config,
  ...
}: let
  vars = import ./variables.nix;
in {
  virtualisation.oci-containers.containers = {
    homeassistant = {
      image = "ghcr.io/home-assistant/home-assistant:stable";
      autoStart = true;

      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "/home/alex/docker/homeassistant:/config:rw"
        "/run/dbus:/run/dbus:ro"
      ];
      ports = ["8124:8123/tcp"];
      networks = [
        "t2_proxy"
      ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.ha-local.entrypoints" = "https";
        "traefik.http.routers.ha-local.rule" = "Host(`homeassistant.local`)";
        "traefik.http.routers.ha-local.tls" = "true";
        "traefik.http.services.ha.loadbalancer.server.port" = "8123";
      };
      log-driver = vars.common.logDriver;
      extraOptions = [
        # Remove --privileged unless absolutely needed
        # Add specific devices if you have Zigbee/Bluetooth/etc.
        # "--device=/dev/ttyUSB0:/dev/ttyUSB0"
      ];
    };
  };

  # Optional: stronger restart policy (oci-containers defaults to "unless-stopped")
  systemd.services."podman-homeassistant".serviceConfig.Restart = lib.mkOverride 90 "always";

  # Root target for easy management (optional but nice)
  systemd.targets."podman-compose-homeassistant-root" = {
    unitConfig.Description = "Root target for Home Assistant container";
    wantedBy = ["multi-user.target"];
  };
}
