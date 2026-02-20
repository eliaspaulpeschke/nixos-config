{ 
  description = "starting point flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    }; 

    nixvim = {
     url = "github:nix-community/nixvim";
     inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, nixvim, nixos-hardware, ... }@inputs: {

    homeConfigurations."peschkee" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; }; 
      modules = [ ./home/peschkee.nix nixvim.homeModules.nixvim ];
    };

    nixosConfigurations.twinkpad = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";  

      specialArgs = { inherit inputs; }; 

      modules = [
        ./overlays.nix

	./nixos

        nixos-hardware.nixosModules.lenovo-thinkpad-t495

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true; 
          home-manager.sharedModules = [ nixvim.homeModules.nixvim ]; 
	  home-manager.extraSpecialArgs = { inherit inputs; };
	  home-manager.backupFileExtension = "bak";
          home-manager.users.elias = import ./home;

        }
      ];
    };
  };
}

