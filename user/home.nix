{ config, pkgs, ... }:

{
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
    waybar
    nextcloud-client
    ripgrep
    fd
    fzf
	gcc # Required for Tree-sitter
	spotify
	spicetify-cli
	fastfetch
	hyprcursor
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

  programs.alacritty = {
    enable = true;
	settings = {
		window.opacity = 0.90;
	};
  };



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




  programs.waybar = {
    enable = true;
    systemd = {
      target = "graphical-session.target";
    };
    style = ''
	* {
          font-family: JetBrainsMono Nerd Font;
          font-size: 12pt;
          }

	window#waybar {
	    background-color: rgba(43, 48, 59, 0.5);
	    border-bottom: 3px solid rgba(100, 114, 125, 0.5);
	    color: #ffffff;
	    transition-property: background-color;
	    transition-duration: .5s;
	}

	window#waybar.hidden {
	    opacity: 0.2;
	}

	/*
	window#waybar.empty {
	    background-color: transparent;
	}
	window#waybar.solo {
	    background-color: #FFFFFF;
	}
	*/

	window#waybar.termite {
	    background-color: #3F3F3F;
	}

	window#waybar.chromium {
	    background-color: #000000;
	    border: none;
	}

	button {
	    /* Use box-shadow instead of border so the text isn't offset */
	    box-shadow: inset 0 -3px transparent;
	    /* Avoid rounded borders under each button name */
	    border: none;
	    border-radius: 0;
	}

	/* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
	button:hover {
	    background: inherit;
	    box-shadow: inset 0 -3px #ffffff;
	}

	/* you can set a style on hover for any module like this */
	#pulseaudio:hover {
	    background-color: #a37800;
	}

	#workspaces button {
	    padding: 5px 5px;
	    background-color: transparent;
	    color: #ffffff;
	}

	#workspaces button:hover {
	    background: rgba(0, 0, 0, 0.2);
	}

	#workspaces button.focused {
	    background-color: #64727D;
	    box-shadow: inset 0 -3px #ffffff;
	}

	#workspaces button.active {
	    color: #9bd0d9
	}

	#workspaces button.default {
	    color: #bdbAf2
	}

	#workspaces button.urgent {
	    background-color: #eb4d4b;
	}

	#mode {
	    background-color: #64727D;
	    box-shadow: inset 0 -3px #ffffff;
	}

	#clock,
	#battery,
	#cpu,
	#memory,
	#disk,
	#temperature,
	#backlight,
	#network,
	#pulseaudio,
	#wireplumber,
	#custom-media,
	#tray,
	#mode,
	#idle_inhibitor,
	#scratchpad,
	#power-profiles-daemon,
	#mpd {
	    padding: 0 10px;
	    color: #ffffff;
	}

	#window,
	#workspaces {
	    margin: 0 4px;
	}

	/* If workspaces is the leftmost module, omit left margin */
	.modules-left > widget:first-child > #workspaces {
	    margin-left: 0;
	}

	/* If workspaces is the rightmost module, omit right margin */
	.modules-right > widget:last-child > #workspaces {
	    margin-right: 0;
	}

	#clock {
	    background-color: #64727D;
	}

	#battery {
	    background-color: #ffffff;
	    color: #000000;
	}

	#battery.charging, #battery.plugged {
	    color: #ffffff;
	    background-color: #26A65B;
	}

	@keyframes blink {
	    to {
		background-color: #ffffff;
		color: #000000;
	    }
	}

	/* Using steps() instead of linear as a timing function to limit cpu usage */
	#battery.critical:not(.charging) {
	    background-color: #f53c3c;
	    color: #ffffff;
	    animation-name: blink;
	    animation-duration: 0.5s;
	    animation-timing-function: steps(12);
	    animation-iteration-count: infinite;
	    animation-direction: alternate;
	}

	#power-profiles-daemon {
	    padding-right: 15px;
	}

	#power-profiles-daemon.performance {
	    background-color: #f53c3c;
	    color: #ffffff;
	}

	#power-profiles-daemon.balanced {
	    background-color: #2980b9;
	    color: #ffffff;
	}

	#power-profiles-daemon.power-saver {
	    background-color: #2ecc71;
	    color: #000000;
	}

	label:focus {
	    background-color: #000000;
	}

	#cpu {
	    background-color: #2ecc71;
	    color: #000000;
	}

	#memory {
	    background-color: #9b59b6;
	}

	#disk {
	    background-color: #964B00;
	}

	#backlight {
	    background-color: #90b1b1;
	}

	#network {
	    background-color: #2980b9;
	}

	#network.disconnected {
	    background-color: #f53c3c;
	}

	#pulseaudio {
	    background-color: #f1c40f;
	    color: #000000;
	}

	#pulseaudio.muted {
	    background-color: #90b1b1;
	    color: #2a5c45;
	}

	#wireplumber {
	    background-color: #fff0f5;
	    color: #000000;
	}

	#wireplumber.muted {
	    background-color: #f53c3c;
	}

	#custom-media {
	    background-color: #66cc99;
	    color: #2a5c45;
	    min-width: 100px;
	}

	#custom-media.custom-spotify {
	    background-color: #66cc99;
	}

	#custom-media.custom-vlc {
	    background-color: #ffa000;
	}

	#temperature {
	    background-color: #f0932b;
	}

	#temperature.critical {
	    background-color: #eb4d4b;
	}

	#tray {
	    background-color: #2980b9;
	}

	#tray > .passive {
	    -gtk-icon-effect: dim;
	}

	#tray > .needs-attention {
	    -gtk-icon-effect: highlight;
	    background-color: #eb4d4b;
	}

	#idle_inhibitor {
	    background-color: #2d3436;
	}

	#idle_inhibitor.activated {
	    background-color: #ecf0f1;
	    color: #2d3436;
	}

	#mpd {
	    background-color: #66cc99;
	    color: #2a5c45;
	}

	#mpd.disconnected {
	    background-color: #f53c3c;
	}

	#mpd.stopped {
	    background-color: #90b1b1;
	}

	#mpd.paused {
	    background-color: #51a37a;
	}

	#language {
	    background: #00b093;
	    color: #740864;
	    padding: 0 5px;
	    margin: 0 5px;
	    min-width: 16px;
	}

	#keyboard-state {
	    background: #97e1ad;
	    color: #000000;
	    padding: 0 0px;
	    margin: 0 5px;
	    min-width: 16px;
	}

	#keyboard-state > label {
	    padding: 0 5px;
	}

	#keyboard-state > label.locked {
	    background: rgba(0, 0, 0, 0.2);
	}

	#scratchpad {
	    background: rgba(0, 0, 0, 0.2);
	}

	#scratchpad.empty {
		background-color: transparent;
	}

	#privacy {
	    padding: 0;
	}

	#privacy-item {
	    padding: 0 5px;
	    color: white;
	}

	#privacy-item.screenshare {
	    background-color: #cf5700;
	}

	#privacy-item.audio-in {
	    background-color: #1ca000;
	}

	#privacy-item.audio-out {
	    background-color: #0069d4;
	}


    '';
    settings = {
      mainBar = {
        position = "top";
	#height = 30;
	spacing = 4;
	output = [ "DP-1" ];
	modules-left =  [ "hyprland/workspaces" ];
	modules-center = [ "hyprland/window"];
	modules-right = [  
	#"mpd"
        "idle_inhibitor"
        "pulseaudio"
        "network"
        "keyboard-state"
        "tray"
        "clock"
	];

	# Modules Configuration
	"hyprland/workspaces" = {
	   disable-scroll = true;
	   format = "{icon}";
	   format-icons = {
             urgent = "";
             active = "";        
	     default = "";
	   };


	};
	 ## Is scratchpad possible with hyprland? ##
#	"sway/scratchpad" = {
#          format = "{icon} {count}";
#	  show-empty = false;
#	  format-icons = [ "" "" ]; 
#	  
#	  tooltip = true;
#	  tooltip-format = "{app}: {title}";
#	};
	
	"keyboard-state" = {
	   numlock = true;
	   capslock = true;
	   format = "{name} {icon}";
	   format-icons = {
             locked = "";
             unlocked = "";
	    };
	};
	"idle_inhibitor" = {
	  format = "{icon}";
	  format-icons = {
	    activated = "";
	    deactivated = "";
	  };
	};

	"pulseaudio" = {
	  format = "{volume}% {icon} {format_source}";
	  format-bluetooth = "{volume}% {icon} {format_source}";
	  format-bluetooth-muted = "󰝟 {icon} {format_source}";
	  format-muted = "󰝟 {icon} {format_source}";
	  format-source = "{volume}% ";
	  format-source-muted = "";
	  format-icons = {
	     headphone = "";
             phone = "";
             portable = "";
             default = ["" "" ""];
	  };
	  on-click = "pavucontrol";
	};
	
	"network" = {
	   format-wifi = "{essid} ({signalStrength}%) ";
	   format-ethernet = "{ipaddr}/{cidr} 󰈀";
	   tooltip-format = "{ifname} via {gwaddr}";
	   format-linked = "{ifname} (No IP)";
	   format-disconnected = "Disconnected ";
	   format-alt = "{ifname}: {ipaddr}/{cidr}";
	};

        "tray" = {
	icon-size = 21;
	spacing = 10;
	};

	"clock" = {
	timezone = "Australia/Melbourne";
	tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format-alt = "{:%Y-%m-%d}";
	};

      }; # mainBar
      }; # settings
  }; # Waybar 
  




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
