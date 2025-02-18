{ 
  description = "starting point flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
     url = "github:sodiboo/niri-flake";
    };

    nixvim = {
     url = "github:nix-community/nixvim";
     inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, niri, nixvim, ... }@inputs: {

    nixosConfigurations.twinkpad = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";  

      specialArgs = { inherit inputs; }; 

      modules = [
        ./configuration.nix

	inputs.niri.nixosModules.niri (import ./niri)

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true; 
          home-manager.sharedModules = [ nixvim.homeManagerModules.nixvim ]; 
      
          home-manager.users.elias = import ./home.nix;

        }
      ];
    };
  };
}

