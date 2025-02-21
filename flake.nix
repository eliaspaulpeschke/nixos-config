{ 
  description = "starting point flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    }; 

    stylix.url = "github:danth/stylix";

    niri = {
     url = "github:sodiboo/niri-flake";
    };

    nixvim = {
     url = "github:nix-community/nixvim";
     inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, niri, nixvim, stylix, ... }@inputs: {

    nixosConfigurations.twinkpad = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";  

      specialArgs = { inherit inputs; }; 

      modules = [
        ./configuration.nix

	niri.nixosModules.niri

	./niri

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = false;
          home-manager.useUserPackages = true; 
          home-manager.sharedModules = [ nixvim.homeManagerModules.nixvim ]; 
	  home-manager.backupFileExtension = "bak";
      
          home-manager.users.elias = import ./home.nix;

        }
      ];
    };
  };
}

