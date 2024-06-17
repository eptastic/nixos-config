{ pkgs, config, lib, ... }:

{
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

}
