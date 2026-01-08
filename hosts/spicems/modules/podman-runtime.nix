{...}: {
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    autoPrune.enable = true;
  };

  virtualisation.oci-containers.backend = "podman";

  systemd.services.podman.enable = true;
  systemd.sockets.podman.enable = true;
}
