{
  description = "Home Manager configuration of dan";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    catppuccin.url = "github:catppuccin/nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {nixpkgs, ...}: let
    lib = import ./lib.nix {inherit inputs;};
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    nixosConfigurations = {
      "pomelo" = lib.mkNixosConfig {
        hostname = "pomelo";
      };

      "guava" = lib.mkNixosConfig {
        hostname = "guava";
      };
    };

    homeConfigurations = {
      "dan" = lib.mkHomeManagerConfig {
        username = "dan";
      };
    };
  };
}
