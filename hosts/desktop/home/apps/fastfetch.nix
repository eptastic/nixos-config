{...}:

{
	programs.fastfetch = {
		enable = true;
		settings = {
			schema = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
			logo = {
				type = "sixel";
				source = "~/nixos-config/assets/wallpaper/cyber_yellow_cropped.jpg";
				height = 21;
				padding = {
					top = 2;
					left = 3;
					right = 3;
				};
			};
			modules = [
			{
				type = "custom";
				format = "";
			}
			{
				type = "custom";
				format = "";
			}
			{
				type = "custom"; # // HardwareStart
            # {#1} is equivalent to `\u001b[1m`. {#} is equivalent to `\u001b[m`
				format = "┌─────────── {#1}Hardware Information{#} ───────────┐";
			}
			{
            type = "host";
            key = "  󰌢";
			}
        	{
            type = "cpu";
            key = "  󰻠";
        	}
        	{
            type= "gpu";
            key = "  󰍛";
        	}
			{
            type = "disk";
            key = "  ";
			}
			{
            type = "memory";
            key = "  󰑭";
			}
			{
            type = "swap";
            key = "  󰓡";
			}
			{
            type = "display";
            key = "  󰍹";
			}
			{
            type = "bluetooth";
            key = "  ";
			}
			{
            type  ="sound";
            key = "  ";
			}
			{
            type = "custom"; # SoftwareStart
            format = "├─────────── {#1}Software Information{#} ───────────┤";
			}
			{
            type = "title";
            key = "  ";
            format = "{1}@{2}";
			}
			{
            type = "os";
            key = "  󱄅"; # Just get your distro's logo off nerdfonts.com
			}
			{
            type = "kernel";
            key = "  ";
            format = "{1} {2}";
			}
			{
            type = "lm";
            key = "  󰧨";
			}
			{
            type = "de";
            key = "  ";
			}
			{
            type = "wm";
            key = "  ";
			}
			{
            type = "shell";
            key = "  ";
			}
			{
            type = "terminal";
            key = "  ";
			}
			{
            type = "terminalfont";
            key = "  ";
			}
			{
            type = "theme";
            key = "  󰉼";
			}
			{
            type = "icons";
            key = "  󰀻";
			}
			{
            type = "wallpaper";
            key = "  󰸉";
			}
			{
            type = "packages";
            key = "  󰏖";
			}
			{
            type = "uptime";
            key = "  󰅐";
			}
			{
            type = "media";
            key = "  󰝚";
			}
			{
            type = "localip";
            key = "  󰩟";
            compact = true;
			}
			{
            type = "publicip";
            key = "  󰩠";
			}
			{
            type = "custom"; # InformationEnd
            format = "└────────────────────────────────────────────┘";
			}
			{
            type = "colors";
            paddingLeft = 2;
            symbol = "circle";
			}
			{
		  type = "custom"; 
            # Add Spacing to the bottom 
          format = "";
		  	}

		  	];

		};

	};



}
