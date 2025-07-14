# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./git.nix #Disabled until I enabled home-manager
    ];
  
  nix.settings = {
		experimental-features = [ "nix-command" "flakes" ];
		trusted-users = [ "alex" ];
	};
	
	

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "monero_nix"; # Define your hostname.


  # Enable networking
  networking.networkmanager.enable = true;
  networking.interfaces.eth0.ipv4.addresses = [ {
    address = "172.16.20.10";
    prefixLength = 16;
  } ];
  networking.defaultGateway = "172.16.10.1";
  networking.nameservers = [ "1.1.1.1" ];


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
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = 
      [ 
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEjTsjnuQ4O4AxiVpWvxw1U7ANzLi0s1F1e0Yhf+H+Iv alex@spicems" 
		  
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE7OtEEtxBTK7J/NwHh+w+whBdIDR+jRxZjIb0jLNqP8 alex@nixos"	
			];
    packages = with pkgs; [
      monero-cli
    ];
  };

 # Generate SSH config file under /home/alex/.ssh
#  home.file.".ssh/config" = {
#    text = ''
#      Host github.com
#        User git
#        IdentityFile /etc/ssh/ssh_host_ed25519_key
#        StrictHostKeyChecking no
#    '';
#    target = "/home/alex/.ssh/config";
#  };
#}


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
      after = [ "network.target" ];

      # Service management
      serviceConfig = {
        Type = "forking";
#        PIDFile = "/run/monero/monerod.pid";
        ExecStart = "${pkgs.monero-cli}/bin/monerod --config-file=/etc/monero/monerod.conf --data-dir=/var/lib/monero/.bitmonero --non-interactive --detach"; 
#--pidfile /run/monero/monerod.pid
	ExecStop = "${pkgs.monero-cli}/bin/monerod stop";  # Gracefully stop the node
#	ExecStartPost = "/bin/sleep 2"; #Allow a brief pause after forking to ensure the PID is written
        Restart = "always";
        RestartSec = 30;

	TimeoutStartSec = "0";

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

  # Open ports in the firewall.
   networking.firewall = {
     enable = true;
     allowedTCPPorts = [ 18080 18081 18089 9100 ];
     allowedUDPPorts = [ 18080 18081 18089 9100 ];
   };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
