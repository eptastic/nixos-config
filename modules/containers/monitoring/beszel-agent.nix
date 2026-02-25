{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.my.beszel.agent;
in {
  options.my.beszel.agent = {
    enable = lib.mkEnableOption "Beszel agent (Docker/Podman monitoring + SMART + extra FS)";

    hubUrl = lib.mkOption {
      type = lib.types.str;
      example = "http://192.168.1.10:8090";
      description = "Full URL to your Beszel hub (including port)";
    };

    tokenFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to the TOKEN secret file (from sops-nix)";
    };

    keyFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to the KEY (SSH public key) secret file";
    };

    smartDevices = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      example = ["/dev/nvme0n1" "/dev/sda" "/dev/sdb"];
      description = "Device paths for SMART monitoring (boot NVMe + array drives)";
    };

    extraFilesystems = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      example = {
        "/tank/.beszel" = "tank"; # appears as "tank"
        "/tank/data" = "Data"; # appears as "Data" (nice name)
      };
      description = "Host path → friendly name in Beszel (e.g. ZFS datasets)";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/beszel-agent";
      description = "Persistent data directory for the agent";
    };

    socketDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/run/beszel";
      description = "Directory for the agent socket";
    };
  };

  config = lib.mkIf cfg.enable {
    # Ensure Podman socket is available (rootful, Docker-compatible)
    virtualisation.podman.dockerSocket.enable = true;

    virtualisation.oci-containers.containers.beszel-agent = {
      image = "henrygd/beszel-agent:alpine"; # alpine includes smartctl
      autoStart = true;
      extraOptions =
        [
          "--network=host"
          "--name=beszel-agent"
          "--cap-add=SYS_RAWIO"
          "--cap-add=SYS_ADMIN"
        ]
        ++ (map (dev: "${dev}:${dev}") cfg.smartDevices); # bind devices for SMART

      volumes =
        [
          "${cfg.dataDir}:/var/lib/beszel-agent"
          "${cfg.socketDir}:/beszel_socket"
          "/var/run/docker.sock:/var/run/docker.sock:ro"
          ## Mount secretsFile
          "/run/secrets/beszel:/secrets:ro"
        ]
        ++ (lib.mapAttrsToList (hostPath: name: "${hostPath}:/extra-filesystems/${name}:ro") cfg.extraFilesystems);

      environment = {
        LISTEN = "/beszel_socket/beszel.sock";
        HUB_URL = cfg.hubUrl;
        TOKEN_FILE = cfg.tokenFile;
        KEY_FILE = cfg.keyFile;
        DOCKER_HOST = "unix:///var/run/docker.sock";
      };
    };

    # Create directories
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0755 root root - -"
      "d ${cfg.socketDir} 0755 root root - -"
    ];

    # Wait for sops secrets
    systemd.services."podman-beszel-agent" = {
      after = ["sops-nix.service"];
      wants = ["sops-nix.service"];
    };
  };
}
