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
  }: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    nixosConfigurations = let
      mkNixosConfig = {
        hostname,
        modules ? [],
        baseModules ? [
          home-manager.nixosModules.home-manager
          ./roles/common.nix
          ./hosts/${hostname}
        ],
      }:
        nixpkgs.lib.nixosSystem {
          modules = baseModules ++ modules;
          specialArgs = {inherit inputs;};
        };
    in {
      "pomelo" = mkNixosConfig {
        hostname = "pomelo";
        modules = [ ./roles/desktop.nix ];
      };

      "guava" = mkNixosConfig {
        hostname = "guava";
        modules = [ ./roles/desktop.nix ];
      };
    };

    homeConfigurations = let
      mkHomeManagerConfig = {
        username,
        system ? "x86_64-linux",
      }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};

          extraSpecialArgs = {inherit inputs;};

          modules = [
            ./home/${username}
          ];
        };
    in {
      "dan" = mkHomeManagerConfig {
        username = "dan";
      };
    };
  };
}
