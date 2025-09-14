{inputs, ...}: {
  mkNixosConfig = {
    hostname,
    username ? "dan",
    modules ? [],
    baseModules ? [
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
      inputs.impermanence.nixosModules.impermanence
      ./nixos/modules
      ./nixos/hosts/${hostname}
    ],
  }: let
    mkHomes = [
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit inputs hostname;};

          sharedModules = [
            inputs.catppuccin.homeModules.catppuccin
            inputs.nixvim.homeModules.nixvim
            ./home/modules
          ];

          users.${username}.imports = [
            ./home/${username}
          ];
        };
      }
    ];
    pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux;
  in
    inputs.nixpkgs.lib.nixosSystem {
      modules = baseModules ++ modules ++ mkHomes;
      specialArgs = {inherit inputs hostname pkgs-unstable;};
    };
}
