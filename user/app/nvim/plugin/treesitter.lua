-- the treesitter docs have no () below. check this
require'nvim-treesitter.install'.compilers = { "gcc" }
require('nvim-treesitter.configs').setup({
    ensure_installed = {
--	"nix",
--	"vim",
--	"bash",
--	"lua",
    },
    
    auto_install = false,

    highlight = { enable = true },

    indent = { enable = true },
})
