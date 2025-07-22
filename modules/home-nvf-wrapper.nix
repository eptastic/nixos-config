{ pkgs, inputs, system, ... }: {
	home.packages = [ inputs.packages.${system}.nvf-nvim ];
}
