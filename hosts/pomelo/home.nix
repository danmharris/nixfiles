{ pkgs, ... }:

{
  home.packages = with pkgs; [
    spotify
    discord
    alacritty
    mumble
  ];
}
