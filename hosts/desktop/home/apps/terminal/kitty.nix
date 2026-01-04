{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs.kitty = {
    enable = true;
    themeFile = "GruvboxMaterialDarkSoft";
    settings = {
      cursor_shape = "block";
      cursor_shape_unfocused = "hollow";
      cursor_trail = 10;
    };
    #builtins.readFile ./config.lua;
  };
}
