{ ... }:

{
  programs.git = {
    enable = true;
    userName = "eptastic";
    userEmail = "github.9uvss@aleeas.com";
    aliases = {
			s = "status";
      p = "push";
      co = "checkout";
      cm = "commit";
     };
	extraConfig = {
	  init.defaultBranch = "master";
	};
  };

}
