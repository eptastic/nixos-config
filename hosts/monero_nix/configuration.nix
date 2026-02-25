# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: let
  ipAddr = "172.16.20.10";
  gateway = "172.16.20.1";
  domainName = "/run/secrets/domain/name";
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/containers/monitoring/beszel-agent.nix
    ./security/secrets.nix

    #./git.nix #Disabled until I enabled home-manager
  ];

  # Create the directory for the keys.txt for AGE file
  systemd.tmpfiles.rules = [
    "d /var/lib/sops 0700 root root -"
    "d /var/lib/sops/age 0700 root root -"
  ];

  ## Place into dedicated file when ready
  my.beszel.agent = {
    enable = true;
    hubUrl = "http://172.16.20.50:8090";
    tokenFile = "/secrets/token";
    keyFile = "/secrets/api-key";

    #  smartDevices = [
    #      "/dev/nvme0n1"   # your boot drive
    #      "/dev/sda" "/dev/sdb" "/dev/sdc" "/dev/sdd" "/dev/sde" "/dev/sdf"  # your 6 array drives
    #    ];
    #
    #    extraFilesystems = {
    #      "/tank/.beszel" = "tank";           # or "storage__Tank" for pretty name
    #      # add more ZFS datasets here
    #    };
  };

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["alex"];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "monero_nix"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;
  networking.interfaces.eth0.ipv4.addresses = [
    {
      address = "${ipAddr}";
      prefixLength = 24;
    }
  ];
  networking.defaultGateway = gateway;
  #networking.nameservers = [gateway]; #Disable default name servers from FW

  # Set your time zone.
  time.timeZone = "Australia/Melbourne";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alex = {
    isNormalUser = true;
    description = "alex";
    extraGroups = ["networkmanager" "wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEjTsjnuQ4O4AxiVpWvxw1U7ANzLi0s1F1e0Yhf+H+Iv alex@spicems"

      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE7OtEEtxBTK7J/NwHh+w+whBdIDR+jRxZjIb0jLNqP8 alex@nixos"
    ];
    packages = with pkgs; [
      monero-cli
    ];
  };

  ## Monero User and Group
  users.groups.monero = {};

  users.users.monero = {
    isSystemUser = true;
    createHome = true;
    group = "monero";
  };

  # Ensure the required directories and permissions
  environment.etc."monero/monerod.conf" = {
    user = "monero";
    group = "monero";
    mode = "0640";

    text = ''
      # Data directory (blockchain db and indices)
      data-dir=/var/lib/monero/.bitmonero

      # Log file
      log-file=/var/log/monero/monerod.log

      # P2P configuration
      # p2p-bind-ip=0.0.0.0            # Bind to all interfaces (the default)
      # p2p-bind-port=18080            # Bind to default port

      # RPC configuration
      public-node=1
      rpc-restricted-bind-ip=0.0.0.0            # Bind restricted RPC to all interfaces
      rpc-restricted-bind-port=18089            # Bind restricted RPC on custom port to differentiate from default unrestricted RPC (18081)
      no-igd=1                       # Disable UPnP port mapping

      # ZMQ configuration
      no-zmq=1

      # Block known-malicious nodes from a DNSBL
      enable-dns-blocklist=1

      # Set download and upload limits, if desired
      limit-rate-up=128000 # 128000 kB/s == 125MB/s == 1GBit/s; a raise from default 2048 kB/s; contribute more to p2p network
      limit-rate-down=500000 # 500MB/s; a raise from default 2048 kB/s; contribute more to p2p network
    '';
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    monero-cli
    tor
    prometheus-node-exporter
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #toybox
    htop
    vnstat
    git
    fastfetch
    wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  ## Monero Systemd Service
  # Enable the Monero full node service
  systemd.services.monerod = {
    #enable = !builtins.pathExists "/etc/systemd/system/monerod.service";

    description = "Monero Full Node (Mainnet)";
    after = ["network.target"];

    # Service management
    serviceConfig = {
      Type = "simple";
      #      Type = "forking";
      #        PIDFile = "/run/monero/monerod.pid";
      ExecStart = "${pkgs.monero-cli}/bin/monerod --config-file=/etc/monero/monerod.conf --data-dir=/var/lib/monero/.bitmonero --non-interactive";
      #--pidfile /run/monero/monerod.pid
      ExecStop = "${pkgs.monero-cli}/bin/monerod exit"; # Gracefully stop the node
      #	ExecStartPost = "/bin/sleep 2"; #Allow a brief pause after forking to ensure the PID is written
      Restart = "always";
      RestartSec = 30;

      TimeoutStartSec = "30min";
      TimeoutStopSec = "20min";
      KillSignal = "SIGTERM";
      SendSIGKILL = "no"; ## Ensures the service is not killed early

      # Directory creation and permissions
      User = "monero";
      Group = "monero";
      RuntimeDirectory = "monero";
      RuntimeDirectoryMode = "0700";
      StateDirectory = "monero";
      StateDirectoryMode = "0700";
      LogsDirectory = "monero";
      LogsDirectoryMode = "0700";
      ConfigurationDirectory = "monero";
      ConfigurationDirectoryMode = "0700";

      #extraArgs = [
      #  "--log-level=1"  # Minimal logging
      #  "--max-log-file-size=1"  # Reduce log file size
      #];

      # Hardening measures
      # PrivateTmp = true;
      # ProtectSystem = "full";
      # ProtectHome = true;
      # NoNewPrivileges = true;
    };

    # Define dependencies and targets
    wantedBy = ["multi-user.target"];
  };

  services.tor = {
    enable = true;

    relay = {
      enable = true;
      # The key in the attrset becomes the directory name under /var/lib/tor/
      # You can name it whatever you want (mysite, ssh, bitcoind, etc.)
      role = "private-bridge";

      onionServices = {
        "nixnodebest" = {
          # Required: which local port(s) to forward
          # Format: { "onion-port" = "destination"; }
          map = [
            {
              port = 18089;
              target = {
                addr = "127.0.0.1";
                port = 18089;
              };
            }
          ];
          # Optional: version 3 onion address (default nowadays)
          # You can also set version = [ 2 3 ]; but v2 is deprecated
          version = 3;
          # Very optional – if you want deterministic addresses (same key → same .onion)
          # secretKey = "/run/keys/my-onion-ed25519-private-key";
        };
      };
    };
  };
  # Prometheus Node Exporter
  services.prometheus.exporters.node = {
    enable = true;
    listenAddress = "0.0.0.0";
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # require pub key auth
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."nixmonero.best" = {
      enableACME = true;
      forceSSL = true;

      default = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:18089/";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Real-IP $remote_addr;
        '';
      };
    };
  };

  # Open ports in the firewall.
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [80 443 18080 18089 9100]; # Removed 18081
      allowedUDPPorts = [80 443 18080 18089 9100]; # Removed 18081
    };
    nameservers = ["1.1.1.1" "1.0.0.1"];
  };

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "canal_purgatory199@simplelogin.com";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
