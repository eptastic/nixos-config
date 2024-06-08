{ config, pkgs, lib, inputs, ... }:


{

  programs.wezterm = {
	enable = true;
#	package = pkgs.wezterm-nightly;
	extraConfig = ''
		local wezterm = require("wezterm")
		local config = {}
		config.enable_wayland = false
		config.hide_tab_bar_if_only_one_tab = true
		config.window_background_opacity = 0.9
		config.color_scheme = 'Gruvbox Dark (Gogh)'
		return config
	'';
	#builtins.readFile ./config.lua; 

  };

}
