{...}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    initContent = "fastfetch";
    shellAliases = {
      ll = "ls -la";
      ".." = "cd ..";
      vim = "nvim";
      vi = "nvim";
      n = "nvim";
      nixdesktop = "sudo nixos-rebuild switch --flake /home/alex/nixos-config#desktop";
      nixupgrade = "sudo nixos-rebuild switch --upgrade --flake /home/alex/nixos-config#desktop";
      nixmonero = "nixos-rebuild switch --flake /home/alex/nixos-config#monero_nix --target-host monero_nix --ask-sudo-password";
      pihole-nix = "nixos-rebuild switch --flake /home/alex/nixos-config#pihole-nix --target-host pihole-nix --ask-sudo-password";
      spicems-rebuild = "nixos-rebuild switch --flake /home/alex/nixos-config#spicems --target-host spicems --ask-sudo-password";

      # Directory Aliases
      home = "/home/alex/nixos-config/desktop/home/";
      config = "/home/alex/nixos-config/";

      reload-waybar = "killall -SIGTERM waybar && bash /home/alex/.config/hypr/start.sh";
      cfg = "nvim /home/alex/nixos-config/hosts/desktop/configuration.nix";
      hm = "nvim /home/alex/nixos-config/hosts/desktop/home.nix";
      #			nvim_plugin = "cd /home/alex/nixos-config/user/app/nvim/plugin/";
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
