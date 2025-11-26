{...}: {
  programs.nvf = {
    enable = true;
    defaultEditor = true; # Optional: Sets NVF's Neovim as $EDITOR

    settings = {
      vim = {
        # Basic editor behavior
        options = {
          tabstop = 3;
          shiftwidth = 3;
          softtabstop = 3;
          expandtab = true;
          smartindent = true;
          autoindent = true;
          number = true;
          relativenumber = true;
          signcolumn = "yes";
          termguicolors = true;
          mouse = "a";
          clipboard = "unnamedplus";
          breakindent = true;
          undofile = true;
          ignorecase = true;
          smartcase = true;
          updatetime = 250;
          showmode = false;
        };

        # Keymaps
        keymaps = [
          {
            key = "<C-w>>";
            mode = "n";
            silent = true;
            action = ":vertical resize +5<CR>"; # Resize NvimTree / splits
          }
          {
            key = "<C-w><";
            mode = "n";
            silent = true;
            action = ":vertical resize -5<CR>";
          }
        ];

        # NVF Plugins
        filetree.nvimTree = {
          enable = true;
          setupOpts = {
            view = {
              width = 20;
              relativenumber = true;
            };
          };
        };

        visuals = {
          cinnamon-nvim.enable = true;
          indent-blankline.enable = true;
          nvim-cursorline.enable = true;
          nvim-web-devicons.enable = true;
        };
        statusline.lualine.enable = true;
        dashboard.dashboard-nvim.enable = true;
        notify.nvim-notify.enable = true;
        comments.comment-nvim.enable = true;
        telescope.enable = true;
        autocomplete = {
          nvim-cmp.enable = true;
          enableSharedCmpSources = true;
        };
        treesitter.enable = true;
        git = {
          gitsigns.enable = true;
        };
        binds.whichKey.enable = true;
        lsp.trouble.enable = true;
        autopairs.nvim-autopairs.enable = true;
        notes.todo-comments.enable = true;
        navigation.harpoon.enable = true;
        mini.surround.enable = true;
        utility.preview.markdownPreview.enable = true;

        # Languages
        languages = {
          enableTreesitter = true;
          python.enable = true;
          bash.enable = true;
          nix.enable = true;
          #lua.enable = true;
          # javascript.enable = true;
          #typescript.enable = true;
          #rust.enable = true;
        };

        # Formatter (Conform + Alejandra for Nix)
        formatter = {
          conform-nvim = {
            enable = true;
            setupOpts = {
              format_after_save = {
                lspFallback = false;
                timeout_ms = 2000;
              };
              formatters_by_ft = {
                nix = ["alejandra"];
                # lua = ["stylua"];
                python = ["black"];
                #javascript = ["prettier"];
                #typescript = ["prettier"];
              };
            };
          };
        };
      };
    };
  };
}
