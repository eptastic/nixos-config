{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nvf.homeManagerModules.default
    ./apps/file_manager/yazi.nix
    ./apps/terminal/wezterm.nix
    ./apps/terminal/kitty.nix
    ./apps/waybar.nix
    #(if enableNvf then ./app/nvim/nvf.nix else ./app/nvim/nvim.nix)
    #	./app/browser/firefox/firefox.nix # Removed because extns didn't work and its older version
    #    ./apps/spotifyd.nix
    ./apps/shell/zsh.nix
    ./apps/git.nix
    ./apps/fastfetch.nix
    ./apps/hypr/hyprlock.nix
    ./apps/hypr/hyprland.nix
    ./apps/hypr/hypridle.nix
    ./apps/wlogout.nix
    ./apps/nvim/nvf.nix
  ];
  # users."alex" = {
  home.homeDirectory = "/home/alex";
  home.file = {
    "games/.keep" = {
      text = "";
    };
  };
  # };

  home.stateVersion = "23.11";

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    davinci-resolve
    chromium
    gcr
    qmk
    keymapviz
    ledger-live-desktop
    monero-gui
    runelite
    signal-desktop
    #prismlauncher
    #prismlauncher.override { jdks = [ pkgs.jre17_minimal ]; }
    #			jre_minimal # v21 required for MC
    #jre17_minimal
    #modrinth-app
    #			atlauncher
    zola
    geoclue2 # Required for gammastep
    gammastep
    tree
    beets
    nicotine-plus
    wlogout
    thunderbird
    nextcloud-client
    ripgrep
    fd
    fzf
    gcc # Required for Tree-sitter
    #spotify
    tidal-hifi
    spicetify-cli
    #    spotifyd
    playerctl
    #fastfetch
    hyprcursor
    lazygit
    #chafa # Required for Image Previews for LF
    ueberzugpp
    swappy
    waypaper
    cava
    (mpv.override {scripts = [mpvScripts.mpris];})
    hyprpicker
    syncthing
    syncthingtray
    typst
    typst-live
    bitwarden-desktop
    freetube
    alejandra
    gimp
  ];

  programs.discord.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  xdg.configFile."swappy/config".text = ''
    [Default]
    save_dir=${config.home.homeDirectory}/Pictures/Screenshots
    save_filename_format=Screenshot-%Y-%m-%d_%H-%M-%S.png
    early_exit=true
    copy_to_clipboard=true
  '';

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        hashKnownHosts = true;
        addKeysToAgent = "yes";
      };
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "/run/secrets/ssh_keys/nixgithub";
      };
      "spicems" = {
        hostname = "172.16.20.50";
        user = "alex";
        identityFile = "/run/secrets/ssh_keys/spicems";
      };
      "monero_nix" = {
        hostname = "172.16.20.10";
        user = "alex";
        identityFile = "/run/secrets/ssh_keys/monero_nix";
      };
      "laptop-wsl" = {
        hostname = "172.16.10.8";
        user = "alex";
        port = 2222;
        identityFile = "/run/secrets/ssh_keys/alex_laptop";
      };
      "pihole-nix" = {
        hostname = "161.33.78.213";
        user = "root";
        port = 22;
        identityFile = "/run/secrets/ssh_keys/pihole-nix";
      };
    };
  };

  services.gnome-keyring.enable = true;

  services.udiskie = {
    enable = true;
    # Could add preferred file manager here
    settings = {
      program_options = {
        terminal = "${pkgs.wezterm}/bin/wezterm -e ${pkgs.yazi}/bin/yazi";
        # or if term is in $path
        # terminal = "yazi";
      };
    };
  };
  # Enable Oh My Zsh
  programs.zsh = {
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.rofi = {
    enable = true;
  };

  services.cliphist = {
    enable = true;
    systemdTargets = ["config.wayland.systemd.target"];
    allowImages = true;

    extraOptions = [
      "-max-depupe-search"
      "10"
      "-max-items"
      "50"
    ];
  };

  services.mako = {
    enable = true;
    # Sytling
    settings = {
      default-timeout = 5000;
      icons = true;
      border-radius = 15;
    };
  };

  services.nextcloud-client = {
    enable = true;
    startInBackground = false;
  };
}
