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
    beszel = {
      image = "henrygd/beszel:latest";
      autoStart = true;

      ports = ["8090:8090"];

      environment = {
        APP_URL = "http://${localhost}:8090";
        TZ = tz;
      };

      volumes = [
        "${dockerDir}/beszel:/beszel_data"
        "${dockerDir}/beszel_socket:/beszel_socket"
      ];
    };

    beszel-agent = {
      image = "henrygd/beszel-agent:alpine";
      autoStart = true;

      extraOptions = [
        #"--user=1000" # No, run as root so it sees rootful containers
        "--network=host"
        "--name=beszel-agent"
        "--cap-add=SYS_RAWIO"
        "--cap-add=SYS_ADMIN"
      ];

      devices = [
        "/dev/nvme0n1:/dev/nvme0" # Changed to nvme0

        "/dev/sda:/dev/sda"
        "/dev/sdb:/dev/sdb"
        "/dev/sdc:/dev/sdc"
        "/dev/sdd:/dev/sdd"
        "/dev/sde:/dev/sde"
        "/dev/sdf:/dev/sdf" ## Wd 20TB
        "/dev/sdg:/dev/sdg"
      ];

      volumes = [
        "${dockerDir}/beszel-agent:/var/lib/beszel-agent"
        "${dockerDir}/beszel_socket:/beszel_socket"
        "/var/run/docker.sock:/var/run/docker.sock:ro" ## Docker compatible socket (we have docker socket turned on in podman.nix)
        "/thufir2/.beszel:/extra-filesystems/thufir2:ro"
        ## Mount secretsFile
        "/run/secrets/beszel:/secrets:ro"
      ];

      environment = {
        LISTEN = "/beszel_socket/beszel.sock";
        HUB_URL = "http://127.0.0.1:8090";
        TOKEN_FILE = "/secrets/token";
        KEY_FILE = "/secrets/api-key";
        #DOCKER_HOST = "unix:///run/user/1000/podman/podman.sock";
        DOCKER_HOST = "unix:///var/run/docker.sock";
        SMART_DEVICES = "/dev/sdf:WD20TB";
      };
    };
  };

  systemd = {
    tmpfiles.rules = [
      "d ${dockerDir}/beszel 0775 root root - -"
      "d ${dockerDir}/beszel_socket 0775 root root - -"
      "d ${dockerDir}/beszel-agent 0775 root root - -"
    ];
    services = {
      "podman-beszel-agent" = {
        after = ["sops-nix.service"];
        wants = ["sops-nix.service"];
      };
    };
  };
}
