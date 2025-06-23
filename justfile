default:
  just --list

build:
  nixos-rebuild build --flake .

switch:
  sudo nixos-rebuild switch --flake .

sops-updatekeys:
  find -type f -name '*.sops.yml' -exec sops updatekeys {} \;
