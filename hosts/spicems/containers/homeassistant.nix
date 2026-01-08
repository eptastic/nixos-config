{
  pkgs,
  lib,
  config,
  ...
}: {
  networking.firewall.interfaces = let
    matchAll =
      if !config.networking.nftables.enable
      then "podman+"
      else "podman*";
  in {
    "${matchAll}".allowedUDPPorts = [53];
  };

  virtualisation.oci-containers = {
    backend = "podman";

    containers.homeassistant = {
      image = "ghcr.io/home-assistant/home-assistant:stable";
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "/home/alex/docker/homeassistant:/config:rw"
        "/run/dbus:/run/dbus:ro"
      ];
      ports = ["8124:8123/tcp"];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.ha-local.entrypoints" = "websecure";
        "traefik.http.routers.ha-local.rule" = "Host(`homeassistant.local`)";
        "traefik.http.routers.ha-local.tls" = "true";
        "traefik.http.services.ha.loadbalancer.server.port" = "8123";
      };
      log-driver = "journald";
      extraOptions = [
        # Remove --privileged unless absolutely needed
        # Add specific devices if you have Zigbee/Bluetooth/etc.
        # "--device=/dev/ttyUSB0:/dev/ttyUSB0"
      ];
      autoStart = true; # Optional: ensures it starts on boot
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
