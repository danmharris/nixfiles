{
  description = "Home Manager configuration of dan";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    catppuccin.url = "github:catppuccin/nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    catppuccin,
    ...
  }: let
    lib = import ./lib {inherit inputs;};
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    nixosConfigurations."pomelo" = lib.mkNixosSystem {
      modules = [
        ./hosts/pomelo/configuration.nix
      ];
    };

    homeConfigurations."dan" = lib.mkHomeManager {
      inherit pkgs;
      username = "dan";
    };
  };
}
