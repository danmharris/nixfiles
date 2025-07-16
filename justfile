default:
  just --list

build:
  nixos-rebuild build --flake .

diff: build
  nvd diff /run/current-system result

build-iso:
  nix build .#nixosConfigurations.iso.config.system.build.isoImage

switch:
  sudo nixos-rebuild switch --flake .

remote-switch host:
  nixos-rebuild switch --target-host {{host}}.dnhrrs.xyz --build-host {{host}}.dnhrrs.xyz --use-remote-sudo --flake .#{{host}}

sops-updatekeys:
  find -type f -name '*.sops.yml' -exec sops updatekeys {} \;

unlock host:
  ssh -p 2222 root@{{host}}.dnhrrs.xyz
