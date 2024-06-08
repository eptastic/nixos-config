{ config, pkgs, lib, inputs, ... }:

{

  imports = [
	./app/file_manager/yazi.nix
	./app/terminal/wezterm.nix
	./app/bar/waybar.nix
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
	fastfetch
	hyprcursor
	lazygit
	chafa # Required for Image Previews for LF
	ueberzugpp
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

### RANGER IS NOT IN STABLE 23.11!!
#  programs.ranger = {
#  	enable = true; 
#	settings = {
#		preview_images = true;
#	};
#  };

  programs.neovim = 
  let
    toLua = str: "lua << EOF\n${str}\nEOF\n";
    toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
    toFile = file: "${builtins.readFile file}";
  in
  {
    enable = true;
    
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraLuaConfig = ''
    -- Either write lua code here or...

    -- interpolate files like this: 
    ${builtins.readFile ./app/nvim/options.lua}
    
    '';
    plugins = with pkgs.vimPlugins; [
#      lazy-nvim
       plenary-nvim
       nvim-web-devicons
       telescope-fzf-native-nvim
	   dashboard-nvim
       # Configure treesitter languages
	   {
	    plugin = (nvim-treesitter.withPlugins (p: [
	      p.tree-sitter-nix
	      p.tree-sitter-vim
	      p.tree-sitter-bash
          p.tree-sitter-lua
         # p.tree-sitter-c
            ]));
	    type = "lua";
	    config = toFile ./app/nvim/plugin/treesitter.lua;
	   }

	   {
	        ## Define plugin based on nixpkgs
	   	plugin = mini-nvim;
		type = "lua";
		config = toFile ./app/nvim/plugin/mini.lua; 
       }

	   {
	        ## Define plugin based on nixpkgs
	   	plugin = orgmode;
		type = "lua";
		config = toFile ./app/nvim/plugin/orgmode.lua; 
       }

	   {
	        ## Define plugin based on nixpkgs
	   	plugin = gruvbox-nvim;
		config = "colorscheme gruvbox"; 
       }

	   {
	   	plugin = dashboard-nvim; 
		type = "lua";
	        ## Define LuaFile using let bindings above 
		config = toFile ./app/nvim/plugin/dashboard.lua; 
       }
	   {
	   	plugin = telescope-nvim;
		type = "lua";
	        ## Define LuaFile using let bindings above 
		config = toFile ./app/nvim/plugin/telescope.lua; 
       }

	   {
	   	plugin = nvim-tree-lua;
		type = "lua";
		config = "require(\"nvim-tree\").setup()"; 
       }

#	   { plugin = neorg;
#		type = "lua";
#		config = toFile ./app/nvim/plugin/neorg.lua; 
#        }

	   { plugin = comment-nvim;
		type = "lua";
	        ## Define oneline setup
		config = "require(\"Comment\").setup()"; 
        }
     ];


  };

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
