{pkgs, ...}: {
  imports = [
    ../profiles/main.nix
  ];

  home.packages = with pkgs; [
    prismlauncher
  ];
}
