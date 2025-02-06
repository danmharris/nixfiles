{inputs, ...}: {
  mkNixosSystem = {modules}:
    inputs.nixpkgs.lib.nixosSystem {
      inherit modules;
      specialArgs = {inherit inputs;};
    };

  mkNixosHomeManager = {
    username,
    homeManagerModules,
  }: [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${username}.imports =
        [
          ../home/${username}
        ]
        ++ homeManagerModules;
      home-manager.extraSpecialArgs = {inherit inputs;};
    }
  ];

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
