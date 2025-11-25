{ pkgs, lib, ... }:

#let
#        obsidanVault = "/home/alex/Nextcloud/Obsidian_Vault/De_Vries";
#in

{
	vim = {
		theme = { 
			enable = true;
			name = "gruvbox";
			style = "dark";
		};

                git.enable = true;

                #                notes.obsidian = {
                #                  enable = true;
                #                  setupOpts = {
                #                        dir = obsidanVault;
                #                    };
                #                  };
                
                filetree.nvimTree.enable = true;
		statusline.lualine.enable = true;
                dashboard.dashboard-nvim.enable = true;
                notify.nvim-notify.enable = true;
		telescope.enable = true;
		autocomplete.nvim-cmp.enable = true;
                
                
                comments.comment-nvim.enable = true;
	
                lsp.enable = true;

		languages = {
			enableTreesitter = true;
                        python.enable = true;
                        bash.enable = true;
			nix.enable = true;
		};

                assistant = {
                   avante-nvim.enable = true;
                   
                };
        };
}

