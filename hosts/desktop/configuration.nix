# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  wallpaperPath,
  system,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./main-user.nix
    ./system/ledger.nix
    #../../common/core/sops.nix
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ./system/security/secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/alex/.config/sops/age/keys.txt";
    ## Give alex permission to openweather_api_key
    secrets.openweather_api_key = {
      owner = config.users.users.alex.name;
      group = config.users.users.alex.group;
      mode = "0440";
    };
    secrets."ssh_keys/spicems" = {
      owner = config.users.users.alex.name;
      group = config.users.users.alex.group;
    };
    secrets."ssh_keys/monero_nix" = {
      owner = config.users.users.alex.name;
      group = config.users.users.alex.group;
    };
    secrets."ssh_keys/nixgithub" = {
      owner = config.users.users.alex.name;
      group = config.users.users.alex.group;
    };
    secrets."ssh_keys/pihole-nix" = {
      owner = config.users.users.alex.name;
      group = config.users.users.alex.group;
    };
  };

  main-user.enable = true;
  main-user.userName = "alex";

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # Fixed that issue where my 2nd workspace wasn't working
    kernelParams = ["nvidia_drm.fbdev=1"];
    # Allow to build aarch64 systems
    binfmt.emulatedSystems = ["aarch64-linux"];
  };

  system = {
    autoUpgrade = {
      enable = true;
      operation = "switch";
      dates = "weekly";
      allowReboot = true;
    };
  };

  # Disable Hibernation and Sleep.
  systemd.targets = {
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  networking = {
    hostName = "nixos"; # Define your hostname.
    # Enable networking
    networkmanager.enable = true;
  };

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

  # SSD Best Practises
  fileSystems."/".options = ["noatime" "nodiratime" "discard"];
  services = {
    fstrim.enable = true;
    # Allow USB to wake the computer
    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="usb", DRIVER=="usb", ATTR{power/wakeup}="enabled"
    '';
  };

  # Allow unfree and broken pkgs
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
    permittedInsecurePackages = [
      "broadcom-sta-6.30.223.271-59-6.12.62"
    ];
  };

  # Required for Ledger Live USB connection
  users.groups.plugdev = {};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alex = {
    isNormalUser = true;
    description = "Alex Mathison";
    extraGroups = ["networkmanager" "wheel" "plugdev"];
    packages = with pkgs; [
      topgrade
      firefox
      nwg-displays
      bc # used for weather widget
      jq # Used for weather widget
      obsidian
      nwg-bar
      nwg-look
      gtk3
      gtk2
      zsh
      age
      oh-my-zsh
      wget
      git
      mako
      libnotify # Mako depends on this
      swww # Background images
      #rofi-wayland # Application Launcher
      pavucontrol
      slurp
      grim
      swappy # Annotated Screenshots
      nomacs # Qt-based image viewer
      wl-clipboard
      networkmanagerapplet
      killall
      hypridle
      sops
      bat
      audacity
      mpd
    ];
  };

  # Required for Hyprlock to see PAM module. See https://mynixos.com/home-manager/option/programs.hyprlock.enable for more details
  security.pam.services.hyprlock = {};
  security.pam.services.login.enableGnomeKeyring = true;

  # Imports home.nix to configure home-manager for user Alex
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    users.alex = import ./home/home.nix;
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "alex";
  services.journald.extraConfig = "SystemMaxUse=1G";

  # Greetd
  #  services.greetd = {
  #    enable = true;
  #    settings = {
  #      inital_session = {
  #        #command = "${pkgs.hyprland}/bin/Hyprland"; # it used to be {pkgs.greetd.reetd}
  #        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd hyprland";
  #        #        # Next should try Tuigreet (KISS)
  #
  #        user = "alex";
  #      };
  #    };
  #  };

  #	services = {
  #		displayManager = {
  #			enable = true;
  #			sddm = {
  #				wayland.enable = true;
  #				enable = true;
  #				theme = "${import ./sddm-theme.nix {inherit pkgs;}}";
  #			};
  #		};
  #	};

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
    nerd-fonts.caskaydia-cove
    nerd-fonts.jetbrains-mono
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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  # Enable Flakes and Nix Command
  nix.settings.experimental-features = ["nix-command" "flakes"];

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

  services.xserver.videoDrivers = ["nvidia"];
  hardware.graphics = {
    enable = true;
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
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  ## Enable Sound
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

  #  services.samba = {
  #    enable = true;
  #    securityType = "user";
  #    openFirewall = true;
  #    settings = {
  #      global = {
  #      };
  #    };
  #  };
  #
  #  # Allows samba to advertise the shares to windows
  #  services.samba-wsdd = {
  #    enable = true;
  #    openFirewall = true;
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

  ### Stylix ###

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    image = wallpaperPath;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "JetBrainsMono Nerd Font Mono";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "JetBrainsMono Nerd Font Mono";
      };
    };
  };
}
