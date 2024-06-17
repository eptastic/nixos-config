{ config, pkgs, lib, inputs, ... }:


{

  programs.neovim = 
  let
    toLua = str: "lua << EOF\n${str}\nEOF\n";
    toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
    toFile = file: "${builtins.readFile file}";
  in
  {
    enable = true;
    
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraLuaConfig = ''
    -- Either write lua code here or...

    -- interpolate files like this: 
    ${builtins.readFile ./options.lua}
    
    '';
     plugins = with pkgs.vimPlugins; [
#      lazy-nvim
       plenary-nvim
       nvim-web-devicons
       telescope-fzf-native-nvim
       dashboard-nvim
       # Configure treesitter languages
	   
	  #   plugin = (nvim-treesitter.withPlugins (p: [
	  #  		p.nix
			# p.lua
			# p.yaml
	  #  #    p.tree-sitter-nix
	  #  #    p.tree-sitter-vim
	  #  #    p.tree-sitter-bash
   #  #       p.tree-sitter-lua
		 #  # p.tree-sitter-yaml
		 #  # p.tree-sitter-jsonc
		 #  # p.tree-sitter-json
   #       # p.tree-sitter-c
   #          ]));
   	   {
        plugin = nvim-treesitter.withAllGrammars;
	    type = "lua";
	    config = toFile ./plugin/treesitter.lua;
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
		config = "require(\"nvim-tree\").setup()"; 
       }

#	   { plugin = neorg;
#		type = "lua";
#		config = toFile ./app/nvim/plugin/neorg.lua; 
#        }

	   { plugin = comment-nvim;
		type = "lua";
	        ## Define oneline setup
		config = "require(\"Comment\").setup()"; 
        }
     ];


  };



}
