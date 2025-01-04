
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Custom Parsers directory
vim.opt.runtimepath:append("/home/alex/.config/nvim/parsers/")

-- LSP
local lsp = require("lspconfig")
local coq = require("coq")

-- Coq Settings
vim.g.coq_settings = {
	-- Enables autostart for coq - Currently doesnt work.
	auto_start = true,
}


--  Language Servers --

-- Lua - lua-language-server
lsp.lua_ls.setup({})
-- Nix - nixd - with alejandra for code formatting for nix
lsp.nixd.setup({
  cmd = { "nixd" },
  settings = {
    nixd = {
      nixpkgs = {
        expr = "import <nixpkgs> { }",
      },
      formatting = {
        command = { "alejandra" }, -- or nixfmt or nixpkgs-fmt
      },
      -- options = {
      --   nixos = {
      --       expr = '(builtins.getFlake "/PATH/TO/FLAKE").nixosConfigurations.CONFIGNAME.options',
      --   },
      --   home_manager = {
      --       expr = '(builtins.getFlake "/PATH/TO/FLAKE").homeConfigurations.CONFIGNAME.options',
      --   },
      -- },
    },
  },
})
-- -- YAML - yaml-language-server 
lsp.yamlls.setup {}
-- -- JSON
lsp.jsonls.setup {}

-- COQ Completion and Snippets

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.clipboard = 'unnamedplus'

vim.wo.number = true
vim.wo.relativenumber = true

vim.o.signcolumn = 'yes'

vim.o.tabstop = 2
vim.o.shiftwidth = 2

vim.o.updatetime = 300

vim.o.termguicolors = true

vim.o.mouse = 'a'

-- Dont show mode as it's already in status line
vim.opt.showmode = false

vim.g.have_nerd_font = true

vim.opt.breakindent = true

vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Custom Shortcuts

vim.keymap.set("n", "<leader>ft", require("nvim-tree.api").tree.toggle, { desc = "Toggle Nvim-Tree" })

