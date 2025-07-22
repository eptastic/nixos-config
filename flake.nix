{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # 23.11
		
		nvf.url = "github:notashelf/nvf";
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

  outputs = { self, nixpkgs, home-manager, stylix, sops-nix, nvf, ... }@inputs: 
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

			nvfNvim = (nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [ ./modules/nvf.nix ];
    }).neovim;


    in {
			packages.${system} = { 
				nvf-nvim = nvfNvim;	
				default = nvfNvim;
			};	
			## I think this is used for building homeManager remotely. Not used atm 
			#homeManagerModules = {
			#		default = import ./modules/home.nix;
			#		extraSpecialArgs = { inherit inputs; };
			#};

 		  nixosConfigurations = {
			  desktop = nixpkgs.lib.nixosSystem {
				  system = system;
				  specialArgs = {
						inherit inputs nvfNvim;
					};

				  modules = [
					  ./hosts/desktop/configuration.nix
						#					 ./hosts/desktop/system - Don't ref directories unless there is a default.nix file there
					  home-manager.nixosModules.default
					  sops-nix.nixosModules.sops
					  stylix.nixosModules.stylix
					  
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
		 };
    };
}
