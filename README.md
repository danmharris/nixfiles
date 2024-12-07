# Nixfiles

My home-manager configuration used to manage dotfiles on my personal machines.

## Bootstrapping

Ensure zsh is installed and configured as the default shell. Then install Nix
from https://nixos.org/download/.

Enable flakes on the system by adding the following to `~/.config/nix/nix.conf`

```
experimental-features = nix-command flakes
```

Clone this repository into the standard location:

```
git clone git@github.com:danmharris/nixfiles.git ~/nixfiles
```

For the first run the `home-manager` cli won't be available so you'll need a
temporary shell:

```
nix shell 'nixpkgs#home-manager'
```

To apply the config:

```
home-manager switch --flake ~/nixfiles
```

## Limitations

* Due to OpenGL incompatibilities this configuration does not manage the Alacritty
package. This needs to be installed separately.
