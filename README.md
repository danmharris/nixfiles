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
git clone git@github.com:danmharris/nixfiles.git ~/.config/home-manager
```

Run the home-manager flake to build and activate the config

```
nix run home-manager/release-24.05 -- init --switch
```

From now `home-manager` should be available and further modifications can be
made with the home-manager cli:

```
home-manager switch
```

## Limitations

* Due to OpenGL incompatibilities this configuration does not manage the Alacritty
package. This needs to be installed separately.
