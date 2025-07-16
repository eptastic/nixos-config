{ config, pkgs, lib, inputs, ... }:

let
	enableNvf = true;
in
{

  imports = [
	./apps/file_manager/yazi.nix
	./apps/terminal/wezterm.nix
	./apps/waybar.nix
	./apps/nvim/nvim.nix
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
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
 # users."alex" = {
   home.homeDirectory = "/home/alex";
   home.file = {};
 # };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.sessionVariables = {
     EDITOR = "nvim";
  };


  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
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

## Disabled Due to stylix conflicting with this.
#  home.pointerCursor = {
#	gtk.enable = true;
#	package = pkgs.bibata-cursors;
#	name = "Bibata-Modern-Classic";
#	size = 22;
#  };


  nixpkgs.config = {
    allowUnfree = true;
  };


  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/alex/etc/profile.d/hm-session-vars.sh
  #

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;


	programs.ssh = {
    enable = true;
    matchBlocks = {
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
