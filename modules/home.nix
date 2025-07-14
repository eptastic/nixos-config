{ config, pkgs, lib, inputs, ... }:

{
	imports = [
		./nvf.nix
		## Add other global modules
	];

	home = {
		username = "alex";
		homeDirectory = "/home/alex";
	};
	
	## Other global settings
}
