# Nixfiles

My NixOS and Home Manager configuration for my desktops and some servers.

## Adding a new host

### Prerequisites

Create the configuration for the new machine. At a minimum this is
* `nixos/hosts/$hostname/default.nix` (we'll add the `hardware-configuration.nix` later)
* `home/dan/hosts/$hostname.nix`
* An entry in `nixosConfigurations` in `flake.nix`

Build a fresh ISO that has my SSH keys and some useful utilities preloaded

```sh
just build-iso
```

### Booting the installer

Boot up the ISO and connect it to the network. If the device has WiFi this needs
to be done manually.

```sh
systemctl start wpa_supplicant
wpa_cli
> add_network
> set_network 0 ssid "<ssid>"
> set_network 0 psk "<psk>"
> enable_network 0
> quit
```

Then SSH into the machine to continue the install.

### Preparing the disk

My current preferred layout for disks is Btrfs with subvolumes. Partition the disk
as follows:

```sh
parted /dev/nvme0n1
> mklabel gpt
> mkpart ESP fat32 1MB 512MB
> set 1 esp on
> mkpart root btrfs 512MB 100%
> quit
```

Then follow the steps on the [Btrfs wiki page](https://nixos.wiki/wiki/Btrfs) for
creating and mounting the subvolumes.
```

Generate the new hardware configuration:

```sh
nixos-generate-config --root /mnt
```

Scp the hardware configuration over into the correct place in this repository.

### Secrets

Generate a new SSH host key. Then convert it to an age key

```sh
mkdir -p /mnt/etc/ssh
ssh-keygen -t ed25519 -N "" -C "" -f /mnt/etc/ssh_host_ed25519_key
ssh-to-age < /mnt/etc/ssh_host_ed25519_key.pub
```

Copy the age key over and place it into `.sops.yaml`. Then regenerate all the sops
files with `just sops-updatekeys`.

Commit & push.

### Installing

On the installer you can now run:

```sh
nixos-install --no-root-passwd --root /mnt --flake github:danmharris/nixfiles#$hostname
```

Give it a while and when its done you can reboot.
