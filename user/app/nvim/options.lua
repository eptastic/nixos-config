-- nvim tree setup
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Custom Parsers directory
vim.opt.runtimepath:append("/home/alex/.config/nvim/parsers/")

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.clipboard = 'unnamedplus'

vim.wo.number = true
vim.wo.relativenumber = true

vim.o.signcolumn = 'yes'

vim.o.tabstop = 4
vim.o.shiftwidth = 4

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

-- Set runtimepath for tree-sitter nixpkgs

