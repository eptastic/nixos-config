# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./main-user.nix
      #nixvim.homeManagerModules.nixvim
      #../../common/core/sops.nix
      #inputs.home-manager.nixosModules.default
      #inputs.sops-nix.nixosModules.sops
    ];

#  sops.defaultSopsFile = ../../secrets/secrets.yaml;
#  sops.defaultSopsFormat = "yaml";

#  sops.age.keyFile = "/home/user/.config/sops/age/keys.txt";
  
#  sops.secrets.example-key = {};
#  sops.secrets."myservice/my_subdir/my_secret" = {
#    owner = "alex";
#  };

  main-user.enable = true;
  main-user.userName = "alex";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alex = {
    isNormalUser = true;
    description = "Alex Mathison";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    
	  #(if pkgs.obsidian.version == "1.5.3" then electron-25.9.0 else obsidian)
	  obsidian
	  nwg-bar
      nwg-look   
      gtk3
      gtk2
#	  bibata-cursors
#	  bibata-extra-cursors
#	  python3
      zsh
      age
      oh-my-zsh
      wget
      git
      #ranger # moved to home-manger
      mako
      libnotify # Mako depends on this
      alacritty 
      swww # Background images
      rofi-wayland # Application Launcher
      #firefox
      #neofetch
      discord
      pavucontrol
      slurp
      grim
      swappy # Annotated Screenshots
      wl-clipboard
      #ueberzug # Image previews in ranger - Which is no longer maintained
      networkmanagerapplet
      killall
	  #elegant-sddm # SDDM Theme
      #greetd.greetd
     # greetd.regreet
	  swaylock
	  swaylock-fancy
	  hypridle
      sops
      bat
	  audacity
	  gtklock
	  mpd

    ];
  };

  # Imports home.nix to configure home-manager for user Alex
  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs; };
    users = {
      "alex" = import ./user/home.nix;
    };
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "alex";

  # Allow unfree and insecurepackages
  nixpkgs.config.allowUnfree = true;
  # Allow broken packages
  nixpkgs.config.allowBroken = true;

 # Greetd
#  services.greetd.enable = true;
#  services.greetd.settings = rec {
#    inital_session = {
#    	command = "${pkgs.hyprland}/bin/Hyprland"; # it used to be {pkgs.greetd.reetd}
#		user = "alex";
#    };
#  };
  services.displayManager.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.enable = true; 
  services.displayManager.sddm.theme = "${import ./sddm-theme.nix { inherit pkgs; }}";

  qt.enable = true;
	

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
	libsForQt5.qt5.qtquickcontrols2
	libsForQt5.qt5.qtgraphicaleffects

    
  ];
  
  
  # Fonts
  
  fonts.packages = with pkgs; [
    nerdfonts
    #(nerdfonts.override { fonts = [ "CaskaydiaCove Nerd Font" ]; })
    ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

#  users.users.alex.openssh.authorizedKeys.keys = [
#
#    "[172.16.20.1]:6633 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNVTXsnwG08BI8NGQpBgLIBk1HCsyJP/fEEISRyM285USvBqbsBcpO0ws09InB2s06/4AGF8ho1al2nLETsl7eQ="
#    "github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl"
#    "github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg="
#    "172.16.20.1 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEv6JgC12mZNAEzZA9O0suyYoyMMAOYEJpWZd87E9oJ+90qAzUAfva1ZUDXruHHX+o3MAOnfgx3rr/d59d0th2Q="
#    "github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk="
#
#    ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  # Enable Flakes and Nix Command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enabling H Y P R L A N D
  programs.hyprland = {
    enable = true;
	#package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    xwayland.enable = true;
  };
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "0";
    NIXOS_OZONE_WL = "1";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
  };


 # Enabling ZSH?
  programs.zsh = {
    enable = true;
  };

# Enabling nvidia gpu
   
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    #powerManagement.enable = false; #Experimental, and can cause sleep/suspend to fail 
    #powerManagement.finegrained = false; # Only works on Turing GPUs or newer
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  programs.steam = {
    enable = true;
	remotePlay.openFirewall = true;
	dedicatedServer.openFirewall = true;
  };

  ## Desktop Portals - Screensharing etc
  # Disabled to run xorg temporarily
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  
  ## Enable Sound
  sound.enable = false; #Meant to ALSA configs
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    
  };

  ## Enabling regreet and setting custom config directory"
#  programs.regreet = {
#    enable = true;
#    settings = {
#      backgroud = {
#        path = "/usr/share/backgrounds/light-painting-rocks.jpg";
#	fit = "Contain";
#      };
#      GTK = {
#      application_prefer_dark_theme = true;
#	  font_name = "CaskaydiaCove Nerd Font";
#	  theme_name =  "Adwaita";
#      };
#      commands = {
#        reboot = [ "systemctl" "reboot" ];
#	poweroff = [ "systemctl" "poweroff" ];
#      };
#    }; 
#
#  };

	services.mpd = {
		enable = true;
		musicDirectory = "/home/alex/music";
		extraConfig = ''
			audio_output {
				type "pulse"
				name "My PulseAudio"
			}
		'';
		user = "alex";
		network.listenAddress = "any";
		startWhenNeeded = true;

	};


}
