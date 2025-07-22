{ config, pkgs, inputs, nvfNvim, ... }:

{

  imports = [
	./apps/file_manager/yazi.nix
	./apps/terminal/wezterm.nix
	./apps/waybar.nix
		#	(if enableNvf then ./app/nvim/nvf.nix else ./app/nvim/nvim.nix)
#	./app/browser/firefox/firefox.nix # Removed because extns didn't work and its older version
	./apps/spotifyd.nix
	./apps/shell/zsh.nix
	./apps/git.nix
	./apps/fastfetch.nix
	./apps/hypr/hyprlock.nix
	./apps/hypr/hyprland.nix
	./apps/hypr/hypridle.nix
	./apps/wlogout.nix
  ];
 # users."alex" = {
   home.homeDirectory = "/home/alex";
   home.file = {};
 # };

  home.stateVersion = "23.11"; 

  home.sessionVariables = {
     EDITOR = "nvim";
  };


  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
			nvfNvim
			qmk
			keymapviz
			ledger-live-desktop
			monero-gui
			angryipscanner
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
			spotify
			spicetify-cli
			spotifyd
			playerctl
			#fastfetch
			hyprcursor
			lazygit
			#chafa # Required for Image Previews for LF
			ueberzugpp
			vesktop
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
  ];


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;


	programs.ssh = {
    enable = true;
    matchBlocks = {
			"github.com" = {
				hostname = "github.com";
				user = "git";
				identityFile = "/run/secrets/ssh_keys/nixgithub";
			};
      "spicems" = {
        hostname = "172.16.20.1";
        user = "alex";
        identityFile = "/run/secrets/ssh_keys/spicems";
      };
			"monero_nix" = {
				hostname = "172.16.20.10";
				user = "alex";
				identityFile = "/run/secrets/ssh_keys/monero_nix";
			};
    };
  };


  # Enable Oh My Zsh 
  programs.zsh.oh-my-zsh = {
    enable = true;
    theme = "agnoster";
  };

	programs.rofi = {
		enable = true;
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
