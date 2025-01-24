{ ... }:

{

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    initExtra = "fastfetch";
    shellAliases = {
      ll = "ls -la";
      ".." = "cd ..";
      vim = "nvim";
      vi = "nvim";
      n = "nvim";
      nixdefault = "sudo nixos-rebuild switch --flake /home/alex/nixos-config#default";
	 
	 		# Directory Aliases
			home = "/home/alex/nixos-config/user/";
			config = "/home/alex/nixos-config/";
			

		  reload-waybar = "killall -SIGTERM waybar && bash /home/alex/.config/hypr/start.sh";
	  	enxcfg = "nvim /home/alex/nixos-config/configuration.nix";
			enxhom = "nvim /home/alex/nixos-config/user/home.nix";
			nvim_plugin = "cd /home/alex/nixos-config/user/app/nvim/plugin/";
			logout = "sudo pkill -KILL -u alex";

			# Git Aliases
			gs = "git status";
			
			# Cat = Bat
			cat = "bat";

    };
  };
}
