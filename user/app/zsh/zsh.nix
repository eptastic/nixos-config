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
      nixmonero = "sudo nixos-rebuild switch --flake /home/alex/nixos-config#monero_nix --target-host monero_nix --use-remote-sudo";
	 
	 		# Directory Aliases
			home = "/home/alex/nixos-config/user/";
			config = "/home/alex/nixos-config/";
			

		  reload-waybar = "killall -SIGTERM waybar && bash /home/alex/.config/hypr/start.sh";
	  	cfg = "nvim /home/alex/nixos-config/configuration.nix";
			hm = "nvim /home/alex/nixos-config/user/home.nix";
			nvim_plugin = "cd /home/alex/nixos-config/user/app/nvim/plugin/";
			logout = "sudo pkill -KILL -u alex";

			zsh = "source ~/.zshrc";

			# Git Aliases
			gs = "git status -s";

			ga = "git add";
			
			# Cat = Bat
			cat = "bat";

    };
  };
}
