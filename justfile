default:
  just --list

build:
  nixos-rebuild build --flake .

diff: build
  nvd diff /run/current-system result

switch:
  sudo nixos-rebuild switch --flake .

sops-updatekeys:
  find -type f -name '*.sops.yml' -exec sops updatekeys {} \;
