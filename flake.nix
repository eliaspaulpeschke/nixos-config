{ 
  description = "starting point flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
     url = "github:sodiboo/niri-flake";
    };

    nixvim = {
     url = "github:nix-community/nixvim/nixos-24.11";
     inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, niri, nixvim, ... }@inputs: {

    nixosConfigurations.twinkpad = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; 

      specialArgs = { inherit inputs; };

      modules = [
        ./configuration.nix

        niri.nixosModules.niri {
          programs.niri.enable = true;
        }

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
      
          home-manager.users.elias = import ./home.nix;

        }
      ];
    };
  };
}

