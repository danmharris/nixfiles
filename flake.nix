{
  description = "Home Manager configuration of dan";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/20075955deac2583bb12f07151c2df830ef346b4";
    catppuccin.url = "github:catppuccin/nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = inputs @ {
    nixpkgs,
    flake-parts,
    ...
  }: let
    lib = import ./lib.nix {inherit inputs;};
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
      ];

      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            age
            alejandra
            just
            sops
            ssh-to-age
          ];
        };
      };

      flake = {
        nixosConfigurations = {
          iso = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
              ./nixos/hosts/iso.nix
            ];
          };

          cherry = lib.mkNixosConfig {
            hostname = "cherry";
          };

          pomelo = lib.mkNixosConfig {
            hostname = "pomelo";
          };

          guava = lib.mkNixosConfig {
            hostname = "guava";
          };

          lumia = lib.mkNixosConfig {
            hostname = "lumia";
          };
        };
      };
    };
}
