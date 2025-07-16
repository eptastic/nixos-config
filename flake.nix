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
    in
    {
		packages.${system}.default = 
			(nvf.lib.neovimConfiguration {
				pkgs = pkgs;
				modules = [ ./nvf.nix ];
			}).neovim;

	 
		homeManagerModules = {
				default = import ./modules/home.nix;
				extraSpecialArgs = { inherit inputs; };
		};

     nixosConfigurations = {
		   desktop = nixpkgs.lib.nixosSystem {
				 system = system;
			   specialArgs = {inherit inputs;};

				 modules = [
					 ./hosts/desktop/configuration.nix
						#					 ./hosts/desktop/system - Don't ref directories unless there is a default.nix file there
					 inputs.home-manager.nixosModules.default
					 stylix.nixosModules.stylix
					 {
						 _module.args = {
							 wallpaperPath = ./assets/wallpaper/space_brown_hues.jpg;
						 };
					 }
					 sops-nix.nixosModules.sops
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
