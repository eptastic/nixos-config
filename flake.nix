{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # 23.11
	
#	hyprland.url = "github:hyprwm/Hyprland";

    home-manager = {
      url = "github:nix-community/home-manager"; #/release-23.11"
      inputs.nixpkgs.follows = "nixpkgs";
     };

		stylix = {
			url = "github:danth/stylix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		
		sops-nix = {
			url =  "github:Mic92/sops-nix";
			inputs.nixpkgs.follows = "nixpkgs";
		};

  };

  outputs = { nixpkgs, ... }@inputs: 
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {

     nixosConfigurations.default = nixpkgs.lib.nixosSystem {
         specialArgs = {inherit inputs;};
         modules = [
          ./configuration.nix
					./system 
	        # Below refers to the above INPUTS on line 7!! 
	        inputs.home-manager.nixosModules.default
					inputs.stylix.nixosModules.stylix
					inputs.sops-nix.nixosModules.sops
         ];
       };
		
	   homeManagerModules.default = ./user;

    };
}
