{lib, ...}: {
  programs.nvf = {
    enable = true;
    defaultEditor = true;

    settings = {
      vim = {
        # Basic editor behavior
        options = {
          tabstop = 2;
          shiftwidth = 2;
          softtabstop = 2;
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
          conceallevel = 2;
        };

        # Formatter
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
                lua = ["stylua"];
                python = ["black"];
                # javascript = ["prettier"];
                # typescript = ["prettier"];
              };
            };
          };
        };

        # Keymaps
        keymaps = [
          {
            key = "<leader>nn";
            mode = "n";
            action = "<cmd>ObsidianToday<cr>";
            desc = "Open today's daily note";
          }
          {
            key = "<leader>nd";
            mode = "n";
            action = "<cmd>ObsidianDailies<cr>";
            desc = "Opens daily note picker";
          }
          {
            key = "<leader>no";
            mode = "n";
            action = "<cmd>ObsidianOpen<cr>";
            desc = "Open's obsidian client";
          }
          {
            key = "<A-Right>";
            mode = "n";
            silent = true;
            action = ":vertical resize +5<CR>";
          }
          {
            key = "<A-Left>";
            mode = "n";
            silent = true;
            action = ":vertical resize -5<CR>";
          }
          {
            key = "<A-Up>";
            mode = "n";
            silent = true;
            action = ":resize -5<CR>";
          }
          {
            key = "<A-Down>";
            mode = "n";
            silent = true;
            action = ":resize +5<CR>";
          }
        ];

        # File tree
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
          nvim-web-devicons = {
            enable = true;
            setupOpts = {
              strict = true;
              color_icons = true;
              default = true;
            };
          };
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
          vim-fugitive.enable = true;
          gitsigns.enable = true;
        };

        binds.whichKey.enable = true;
        lsp.trouble.enable = true;
        autopairs.nvim-autopairs.enable = true;

        # === Notes section ===
        notes = {
          todo-comments.enable = true;

          obsidian = {
            enable = true;
            setupOpts = {
              workspaces = [
                {
                  name = "De_Vries";
                  path = "~/Nextcloud/Obsidian_Vault/De_Vries";
                }
              ];
              daily_notes = {
                folder = "daily";
                date_format = "%Y/%m/%d";
                default_tags = ["daily"];
              };

              new_notes_location = "current_dir";

              note_id_func = lib.mkLuaInline ''
                function(title)
                  if title and title ~= "" then
                    local clean = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
                    return os.date("%Y-%m-%d") .. "-" .. clean
                  else
                    return os.date("%Y-%m-%d") .. "-new-note"
                  end
                end
              '';

              preferred_link_style = "wiki";
            };
          };

          neorg = {
            enable = true;
            treesitter.enable = true;
            setupOpts = {
              load = {
                "core.defaults".enable = true;
                "core.concealer".enable = true;
                "core.keybinds" = {
                  enable = true;
                  config = {
                    # Add custom keybinds here
                  };
                };
                "core.completion" = {
                  enable = true;
                  config = {
                    engine = "nvim-cmp";
                  };
                };
                "core.ui".config = {};
                "core.dirman" = {
                  enable = true;
                  config = {
                    workspaces = {
                      notes = "~/Nextcloud/neorg/notes";
                    };
                    default_workspace = "notes";
                  };
                };
              };
            };
          };
        };

        navigation.harpoon.enable = true;
        mini.surround.enable = true;

        utility = {
          preview = {
            markdownPreview = {
              enable = true;
              autoStart = false;
              autoClose = true;
              lazyRefresh = true;
            };
          };
          snacks-nvim = {
            enable = true;
            setupOpts.picker.enabled = true;
          };
        };

        # Languages
        languages = {
          enableTreesitter = true;
          python.enable = true;
          bash.enable = true;
          nix.enable = true;
          markdown = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
            lsp.servers = ["marksman"];
            treesitter.enable = true;
            extensions.render-markdown-nvim.enable = true;
          };
          typst = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
            extensions.typst-preview-nvim.enable = true;
          };
          lua.enable = true;
          # javascript.enable = true;
          # typescript.enable = true;
          # rust.enable = true;
        };
      };
    };
  };
}
