{ config, pkgs, lib, inputs, ... }:


{

  imports = [
	./app/file_manager/yazi.nix
	./app/terminal/wezterm.nix
	./app/bar/waybar.nix
	./app/nvim/nvim.nix
	./app/browser/firefox.nix
	./app/spotify/spotifyd.nix
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
    nextcloud-client
    ripgrep
    fd
    fzf
	gcc # Required for Tree-sitter
	spotify
	spicetify-cli
	spotifyd
	playerctl
	fastfetch
	hyprcursor
	lazygit
	#chafa # Required for Image Previews for LF
	ueberzugpp
	vencord
	vesktop
	swappy
	waypaper
	cava
	(mpv.override {scripts = [mpvScripts.mpris];})
	hyprpicker

  ];

  home.pointerCursor = {
	gtk.enable = true;
	package = pkgs.bibata-cursors;
	name = "Bibata-Modern-Classic";
	size = 22;
  };


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



#  programs.alacritty = {
#    enable = true;
#	settings = {
#		window.opacity = 0.90;
#	};
#  };



  programs.git = {
    enable = true;
    userName = "eptastic";
    userEmail = "github.9uvss@aleeas.com";
    aliases = {
      pu = "push";
      co = "checkout";
      cm = "commit";
     };
	extraConfig = {
	  init.defaultBranch = "master";
	};
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    
    shellAliases = {
      ll = "ls -l";
      ".." = "cd ..";
      edit = "nvim";
      vim = "nvim";
      vi = "nvim";
      n = "nvim";
      v = "nvim";
      nixdefault = "sudo nixos-rebuild switch --flake /home/alex/nixos-config#default";
      nixconfig = "cd /home/alex/nixos-config/";
      homeman = "cd /home/alex/nixos-config/user/";
	  org = "cd /home/alex/Nextcloud/org/";
	   
      reload-waybar = "killall -SIGTERM waybar && bash /home/alex/.config/hypr/start.sh";
      enxcfg = "nvim /home/alex/nixos-config/configuration.nix";
	  enxhom = "nvim /home/alex/nixos-config/user/home.nix";
	  nvim_plugin = "cd /home/alex/nixos-config/user/app/nvim/plugin/";
	  logout = "sudo pkill -KILL -u alex";

    };
  };
  # Enable Oh My Zsh 
  programs.zsh.oh-my-zsh = {
    enable = true;
    theme = "agnoster";
  };
    

  services.mako = {
    enable = true;
    icons = true;
    defaultTimeout = 2000;
  };

  services.nextcloud-client = {
    enable = true;
    startInBackground = false;
  };
}
