default:
  just --list

build:
  nixos-rebuild build --flake .

switch:
  sudo nixos-rebuild build --flake .
