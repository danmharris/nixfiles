{hostname, ...}: {
  imports = [
    ./hosts/${hostname}.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "dan";
  home.homeDirectory = "/home/dan";
}
