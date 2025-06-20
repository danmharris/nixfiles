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
        username ? "dan",
        modules ? [],
        baseModules ? [
          home-manager.nixosModules.home-manager
          ./nixos/modules
          ./nixos/modules/common.nix
          ./nixos/hosts/${hostname}
        ],
      }: let
        mkHomes = [
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs;};

              sharedModules = [
                catppuccin.homeModules.catppuccin
                ./home/modules
              ];

              users.${username}.imports = [
                ./home/${username}
              ];
            };
          }
        ];
      in
        nixpkgs.lib.nixosSystem {
          modules = baseModules ++ modules ++ mkHomes;
          specialArgs = {inherit inputs;};
        };
    in {
      "pomelo" = mkNixosConfig {
        hostname = "pomelo";
      };

      "guava" = mkNixosConfig {
        hostname = "guava";
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
            catppuccin.homeModules.catppuccin
            ./home/modules

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
