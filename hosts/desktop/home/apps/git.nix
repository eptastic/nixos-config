{...}: {
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "master";
      user = {
        name = "eptastic";
        email = "github.9uvss@aleeas.com";
      };
      alias = {
        s = "status";
        p = "push";
        co = "checkout";
        cm = "commit";
      };
    };
  };
}
