{
  description = "Home Manager configuration of dan";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    catppuccin.url = "github:catppuccin/nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = inputs @ {flake-parts, ...}: let
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
    };
}
