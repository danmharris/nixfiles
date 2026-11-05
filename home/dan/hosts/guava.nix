{
  pkgs,
  pkgs-unstable,
  ...
}: {
  imports = [
    ../profiles/main.nix
  ];

  home.packages = [
    pkgs.prismlauncher
    pkgs-unstable.faugus-launcher
  ];
}
