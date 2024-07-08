{ config, ... }:

{

  programs.waybar = {
    enable = true;
    systemd = {
	  enable = false;
      target = "graphical-session.target";
    };
    style = ''


	/* Colors (gruvbox) */
	@define-color black #282828;
	@define-color red #cc241d;
	@define-color green #98971a;
	@define-color yellow #d79921;
	@define-color blue #458588;
	@define-color purple #b16286;
	@define-color aqua #689d6a;
	@define-color gray #a89984;
	@define-color brgray #928374;
	@define-color brred	#fb4934;
	@define-color brgreen #b8bb26;
	@define-color bryellow #fabd2f;
	@define-color brblue #83a598;
	@define-color brpurple #d3869b;
	@define-color braqua #8ec07c;
	@define-color white #ebdbb2;
	@define-color bg2 #504945;

	* {
          font-family: JetBrainsMono Nerd Font;
          font-size: 12pt;
          }

	window#waybar {
	    background-color: rgba(0, 0, 0, 0.0);
	    /* border-bottom: 3px solid rgba(100, 114, 125, 0.5); */
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
	    color: @white;
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

	#custom-power,
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
	    color: @white;
	}
	#mpris {
	    padding: 0 10px;
	    color: @white;
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
	    background-color: transparent;
	}

	@keyframes blink {
	    to {
		background-color: #ffffff;
		color: #000000;
	    }
	}

	/* Using steps() instead of linear as a timing function to limit cpu usage */

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
		color: @white;
	    background-color: transparent;
	}

	#network.disconnected {
	    background-color: @red;
	}

	#pulseaudio {
	    background-color: transparent;
	    color: @white;
	}

	#pulseaudio.muted {
	    background-color: #90b1b1;
	    color: #2a5c45;
	}

	#custom-power {
	    background-color: transparent;
	    color: @white;
	/* padding is defined top, right, bottom, left */	
		padding: 0px 20px 0px 10px;
		font-size: 15pt;
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
	    background-color: transparent;
	}

	#tray > .passive {
	    -gtk-icon-effect: dim;
	}

	#tray > .needs-attention {
	    -gtk-icon-effect: highlight;
	    background-color: #eb4d4b;
	}

	#idle_inhibitor {
	    background-color: transparent;
	}

	#idle_inhibitor.activated {
	    background-color: #ecf0f1;
	    color: #2d3436;
	}
	
	#mpris {
	    background-color: #66cc99;
	    color: #2a5c45;
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
	    padding: 0 10px;
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
	spacing = 10;
	output = [ "DP-2" ];
	modules-left = [ /* "mpd" */ "mpris" "idle_inhibitor"];
	modules-center =  [ "hyprland/workspaces" ];
	modules-right = [  
        "pulseaudio"
        "network"
        "tray"
        "clock"
		"custom/power"
	];

	# Modules Configuration
	"hyprland/workspaces" = {
	   disable-scroll = true;
	   format = "{name}";
	   #active-only = false;
	   #all-outputs = true;

	   sort-by-number = true;
	   format-icons = {
			"1" = "1";
			"2" = "2";
			"3" = "3";
			"4" = "4";
			"5" = "5";
			"6" = "6";
			"7" = "7";
			"8" = "8";
			"9" = "9";
	   };
	};

	"custom/power" = {
		format = "{icon}";
		format-icons = "";
		on-click = "wlogout";
		on-click-right = "killall wlogout";
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
	
##	"keyboard-state" = {
#	   numlock = true;
#	   capslock = true;
#	   format = "{name} {icon}";
#	   format-icons = {
#             locked = "";
#             unlocked = "";
#	    };
#	};
	"idle_inhibitor" = {
	  format = "{icon}";
	  format-icons = {
	    activated = "󰈈";
	    deactivated = "󰈉";
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

	"mpd" = {
       format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ";
       format-disconnected = "Disconnected ";
       format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
       interval = 10;
       consume-icons = {
         on = " "; #Icon shows only when "consume" is on
       };
       random-icons = {
         off = "<span color=\"#f53c3c\"></span> "; #Icon grayed out when "random" is off
         on = " ";
	   };
       repeat-icons = {
         on = " ";
       };
       single-icons = {
       on = "1 ";
       };
       state-icons = {
       paused = "";
       playing = "";
	   };
       tooltip-format = "MPD (connected)";
       tooltip-format-disconnected = "MPD (disconnected)";
	};

	"mpris" = {
	  player = "spotify";
	  format = "{player_icon} {title} - {artist} ";
	  format-paused = "{status_icon} {title} - {artist} ";

      player-icons = {
		default = "▶";
		mpv = "🎵";
	  };
	  status-icons = {
		paused = "⏸";
	  };
	  ignored-players = ["firefox"];
	  interval = 1;
	  dynamic-len = 10;
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
  






}
