{pkgs, inputs, ...}: {
  programs.neovim = let
    #   toLua = str: "lua << EOF\n${str}\nEOF\n";
    #   toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
    toFile = file: "${builtins.readFile file}";
  in {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraLuaConfig = ''
      -- Either write lua code here or...

      -- interpolate files like this:
      ${builtins.readFile ./options.lua}

    '';

    # Required for adding language servers
    extraPackages = with pkgs; [
      lua-language-server
      nixd
      alejandra
      yaml-language-server
			tinymist
    ];

		coc = {
			enable = true;
			
			settings = {
        languageserver = {
          tinymist = {
            command = "tinymist";
            filetypes = [ "typst" ];
            settings = {
              formatterMode = "typstyle";
              exportPdf = "onType";
              semanticTokens = "disable";
            };
          };
        };
      };
		};

    plugins = with pkgs.vimPlugins; [
      #      lazy-nvim
      nvim-lspconfig
      nvim-notify
      coq_nvim
      coq-artifacts
      plenary-nvim
      nvim-web-devicons
      telescope-fzf-native-nvim
      dashboard-nvim
      # Configure treesitter languages

      #   plugin = (nvim-treesitter.withPlugins (p: [
      #  		p.nix
      #          ]));
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = toFile ./plugin/treesitter.lua;
      }
      {
        plugin = conform-nvim;
        type = "lua";
        config = toFile ./plugin/conform.lua;
      }


      {
        ## Define plugin based on nixpkgs
        plugin = mini-nvim;
        type = "lua";
        config = toFile ./plugin/mini.lua;
      }

      {
        ## Define plugin based on nixpkgs
        plugin = orgmode;
        type = "lua";
        config = toFile ./plugin/orgmode.lua;
      }

      {
        ## Define plugin based on nixpkgs
        plugin = gruvbox-nvim;
        config = "colorscheme gruvbox";
      }

      {
        plugin = dashboard-nvim;
        type = "lua";
        ## Define LuaFile using let bindings above
        config = toFile ./plugin/dashboard.lua;
      }
      {
        plugin = telescope-nvim;
        type = "lua";
        ## Define LuaFile using let bindings above
        config = toFile ./plugin/telescope.lua;
      }

      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = ''
           require("nvim-tree").setup {
              view = {
                 width = 10,
              }
           }

           vim.keymap.set("n", "<C-w><", function()
              require("nvim-tree.view").resize(-20)
           end, { silent = true })

           vim.keymap.set("n", "<C-w>>", function()
              require("nvim-tree.view").resize(20)
           end, { silent = true })

        '';
      }

      #	   { plugin = neorg;
      #		type = "lua";
      #		config = toFile ./app/nvim/plugin/neorg.lua;
      #        }

      {
        plugin = comment-nvim;
        type = "lua";
        ## Define oneline setup
        config = "require(\"Comment\").setup()";
      }

			
    ];
  };
}
