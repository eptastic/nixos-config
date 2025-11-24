{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # 23.11
		
        nvf-portable.url = "github:eptastic/nvf-portable";

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

  outputs = { self, nixpkgs, home-manager, stylix, sops-nix, nvf-portable, ... }@inputs: 
    let
      system = "x86_64-linux";
    in {
			## I think this is used for building homeManager remotely. Not used atm 
			#homeManagerModules = {
			#		default = import ./modules/home.nix;
			#		extraSpecialArgs = { inherit inputs; };
			#};

 		  nixosConfigurations = {
			  desktop = nixpkgs.lib.nixosSystem {
				  system = system;
				  specialArgs = {
						inherit inputs;
					};

				  modules = [
					  ./hosts/desktop/configuration.nix
						#					 ./hosts/desktop/system - Don't ref directories unless there is a default.nix file there
					  home-manager.nixosModules.default
					  sops-nix.nixosModules.sops
					  stylix.nixosModules.stylix
                                          nvf-portable.nixosModules.nvf-config
					  
						# Additional Args for wallpaper
						{
						  _module.args = {
							 wallpaperPath = ./assets/wallpaper/space_brown_hues.jpg;
						  };
					  }
				 	];
			 };
		

			## Monero_Nix Configuration
		   monero_nix = nixpkgs.lib.nixosSystem {
			   modules = [
				   ./hosts/monero_nix/configuration.nix
					 ./hosts/monero_nix/hardware-configuration.nix
				 ];
			 };
			## Laptop Configuration
		   laptop = nixpkgs.lib.nixosSystem {
			   modules = [
				   ./hosts/laptop/configuration.nix
                                 ./hosts/laptop/hardware-configuration.nix
				 ];
			 };
		 };
    };
}
