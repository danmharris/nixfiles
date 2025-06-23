default:
  just --list

build:
  nixos-rebuild build --flake .

switch:
  sudo nixos-rebuild build --flake .

sops-updatekeys:
  find -type f -name '*.sops.yml' -exec sops updatekeys {} \;
