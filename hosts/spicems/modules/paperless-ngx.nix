{
  config,
  lib,
  pkgs,
  ...
}: let
  service = "paperless";
  cfg = config.homelab.services.${service};
in {
  ########################################
  # Options
  ########################################
  options.homelab.services.${service} = {
    enable = lib.mkEnableOption "Paperless-ngx";

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/paperless";
    };

    mediaDir = lib.mkOption {
      type = lib.types.str;
    };

    consumptionDir = lib.mkOption {
      type = lib.types.str;
    };

    passwordFile = lib.mkOption {
      type = lib.types.path;
    };

    url = lib.mkOption {
      type = lib.types.str;
      description = "Public URL (used for PAPERLESS_URL)";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 28981;
      description = "Local listen port";
    };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Address Paperless binds to";
    };
  };

  ########################################
  # Config
  ########################################
  config = lib.mkIf cfg.enable {
    ####################################
    # Paperless
    ####################################
    services.paperless = {
      enable = true;

      user = "paperless";
      dataDir = cfg.dataDir;
      port = cfg.port;
      address = "172.16.20.50"; ## Change this to cfg.listenAddress

      mediaDir = cfg.mediaDir;
      consumptionDir = cfg.consumptionDir;
      consumptionDirIsPublic = true;

      passwordFile = cfg.passwordFile;

      settings = {
        PAPERLESS_URL = "https://${cfg.url}";
        PAPERLESS_OCR_LANGUAGE = "eng";
        PAPERLESS_TASK_WORKERS = 2;
        PAPERLESS_BIND_ADDR = cfg.listenAddress;
      };
    };

    ####################################
    # Database
    ####################################
    services.postgresql = {
      enable = true;
      ensureDatabases = ["paperless"];
      ensureUsers = [
        {
          name = "paperless";
          ensureDBOwnership = true;
        }
      ];
    };

    ####################################
    # Redis
    ####################################
    services.redis.servers.paperless.enable = true;

    ####################################
    # User
    ####################################
    users.users.paperless = {
      isSystemUser = true;
      group = "paperless";
      home = cfg.dataDir;
    };

    users.groups.paperless = {};

    ####################################
    # Firewall (local only)
    ####################################
    #    networking.firewall.allowedTCPPorts = [
    #      cfg.port # Paperless Port
    #      32400
    #      7979
    #      7878
    #      3923
    #      3306
    #      8124
    #      9091
    #      8081
    #      5055
    #      8989
    #      3000
    #      5000
    #      80
    #      443
    #    ];
  };
}
