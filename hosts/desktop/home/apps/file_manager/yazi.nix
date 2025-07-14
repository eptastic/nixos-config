{ pkgs, config, lib, ... }:


{
#  xdg.configFile."lf/icons".source = ./icons;
  
  programs.yazi.enable = true;

#  programs.lf = {
#
#  	enable = true;
#    
#	settings = {
#	  preview = true;
#	  hidden = true;
#	  drawbox = true;
#	  icons = true;
#	  ignorecase = true;
#
#	};
#	commands = {
##	  dragon-out = ''%${pkgs.xdragon}/bin/xdragon -a -x "$fx"''; ## Drag n drop from the Terminal
##	  editor-open = ''$$EDITOR $f'';
#
#	};
#	
#	previewer = {
#	  keybinding = "i";
#	  source = "${pkgs.ctpv}/bin/ctpv";
#	};
#
#	# set sixel true - This is required for image previewing in Wezterm with lf.
#  	extraConfig = ''
#
#	  set sixel true
#	  &${pkgs.ctpv}/bin/ctpv -s $id
#	  cmd on-quit %${pkgs.ctpv}/bin/ctpv -e $id
#	  set cleaner ${pkgs.ctpv}/bin/ctpvclear
#	'';
#
#  };

}
