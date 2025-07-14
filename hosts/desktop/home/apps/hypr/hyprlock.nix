{ lib, ... }:

let
	gruvbox = import ./themes/gruvbox.nix;
in
{
  programs.hyprlock = {
		enable = true;
		settings = {
			general = {
				disable_loading_bar = false;
				hide_cursor = false;
				no_fade_in = false;
				no_fade_out = false;
			};
			background = lib.mkForce [
				{
					path = "${gruvbox.background_image}";
					blur_passes = 2;
					brightness = 0.5;
					color = "${gruvbox.base}";
				}
			];
			label = lib.mkForce [
				## Time
				{
					monitor = "";
					text = ''cmd[update:1000] echo "$(date +"%R")"'';
					color = "${gruvbox.text}";
					font_size = 90;
					font_family = "${gruvbox.font}";
					position = "-150, -100";
					halign = "right";
					valign = "top";
					shadow_passes = 2;
				}
				## Date
				{
					monitor = "";
					text = ''cmd[update:1000] echo "$(date +"%A, %d %B %Y")"'';
					color = "${gruvbox.text}";
					font_size = 25;
					font_family = "${gruvbox.font}";
					position = "-150, -250";
					halign = "right";
					valign = "top";
					shadow_passes = 2;
				}
				## Weather
				{
					monitor = "";
					text = ''cmd[update:1000] bash /home/alex/.config/hypr/weather.sh'';
					color = "${gruvbox.text}";
					font_size = 50;
					font_family = "${gruvbox.font}";
					position = "90, 70";
					halign = "left";
					valign = "bottom";
					shadow_passes = 2;
				}
				## Weather Location
				{
					monitor = "";
					text = ''cmd[update:1000] echo "Brunswick, Victoria"'';
					color = "${gruvbox.text}";
					font_size = 25;
					font_family = "${gruvbox.font}";
					position = "90, 20";
					halign = "left";
					valign = "bottom";
					shadow_passes = 2;
				}
			]; 
			
			image = {
				monitor = "";
				path = "${gruvbox.display_picture}";
				size = 250;
				border_color = "${gruvbox.accent}";
				rounding = -1;
				position = "0, 75";
				halign = "center";
				valign = "center";
				shadow_passes = 2;
			};

			input-field = lib.mkForce {
				monitor = "";
				size = "300, 50";
				outline_thickness = 4;
				dots_size = 0.2;
				dots_spacing = 0.2;
				dots_center = true;
				outer_color = "${gruvbox.accent}";
				inner_color = "${gruvbox.surface0}";
				font_color = "${gruvbox.text}";
				fade_on_empty = false;
				hide_input = false;
				check_color = "${gruvbox.accent}";
				fail_color = "${gruvbox.red}";
				fail_text = ''<i>$FAIL <b>($ATTEMPTS)</b></i>'';
				capslock_color = "${gruvbox.yellow}";
				position = "0, -185";
				halign = "center";
				valign = "center";
				shadow_passes = 2;

			};
		};
	};
}
