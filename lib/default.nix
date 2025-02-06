{inputs, ...}: {
  mkNixosSystem = {modules}:
    inputs.nixpkgs.lib.nixosSystem {
      inherit modules;
      specialArgs = {inherit inputs;};
    };

  mkHomeManager = {
    pkgs,
    username,
  }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      extraSpecialArgs = {inherit inputs;};

      modules = [
        ./home/${username}
      ];
    };
}
