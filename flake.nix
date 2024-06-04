{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # 23.11

    home-manager = {
      url = "github:nix-community/home-manager"; #/release-23.11"
      inputs.nixpkgs.follows = "nixpkgs";
     };
## Disabled this shit    
#    nixvim = {
#      url = "github:nix-community/nixvim/nixos-23.11";
#      inputs.nixpkgs.follows = "nixpkgs";
#    };

  };

  outputs = { self, nixpkgs, ... }@inputs: 
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {

     nixosConfigurations.default = nixpkgs.lib.nixosSystem {
         specialArgs = {inherit inputs;};
         modules = [
            ./configuration.nix
	    # Below refers to the above INPUTS on line 7!! 
	    inputs.home-manager.nixosModules.default
         ];
       };
    };
}
