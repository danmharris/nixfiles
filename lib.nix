{inputs, ...}: {
  mkNixosConfig = {
    hostname,
    username ? "dan",
    modules ? [],
    baseModules ? [
      inputs.home-manager.nixosModules.home-manager
      ./nixos/modules
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
            inputs.catppuccin.homeModules.catppuccin
            ./home/modules
          ];

          users.${username}.imports = [
            ./home/${username}
          ];
        };
      }
    ];
  in
    inputs.nixpkgs.lib.nixosSystem {
      modules = baseModules ++ modules ++ mkHomes;
      specialArgs = {inherit inputs;};
    };

  mkHomeManagerConfig = {
    username,
    system ? "x86_64-linux",
  }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};

      extraSpecialArgs = {inherit inputs;};

      modules = [
        inputs.catppuccin.homeModules.catppuccin
        ./home/modules

        ./home/${username}
      ];
    };
}
