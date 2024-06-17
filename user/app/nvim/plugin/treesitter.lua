-- the treesitter docs have no () below. check this
require'nvim-treesitter.install'.compilers = { "gcc" }
require('nvim-treesitter.configs').setup({
	-- nvim-treesitter installs parsers in the plugin directory per default. Since the nix store is read-only, this will result in an error. So below must be used.
    parser_install_dir =  "/home/alex/.config/nvim/parsers/",
	--ensure_installed = { "nix" },
    
    auto_install = false, -- Parsers are managed by Nix

    highlight = { enable = true },

    indent = { enable = true },
})


