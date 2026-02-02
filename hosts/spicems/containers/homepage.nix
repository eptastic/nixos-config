{config, ...}: let
  vars = import ./variables.nix;
  dockerDir = vars.system.dockerDir;
  #  arrayDir = vars.system.arrayDir;
in {
  virtualisation.oci-containers.containers = {
    homepage = {
      image = "ghcr.io/gethomepage/homepage:latest";
      autoStart = true;

      ports = ["3002:3000"];

      volumes = [
        "${dockerDir}/homepage:/app/config"
        "/run/podman/podman.sock:/var/run/docker.sock:ro"
      ];

      environment = {
        HOMEPAGE_ALLOWED_HOSTS = "gethomepage.dev,127.0.0.1:3002,172.16.20.50:3002";
      };

      extraOptions = [
        "--userns=keep-id"
        "--security-opt=label=disable"
      ];
    };
  };
}
