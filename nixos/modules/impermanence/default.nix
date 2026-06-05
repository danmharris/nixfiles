{
  config,
  lib,
  utils,
  ...
}: let
  cfg = config.mySystem.impermanence;
in {
  options.mySystem.impermanence.enable = lib.mkEnableOption "impermanence";

  config = lib.mkIf (cfg.enable) {
    users.mutableUsers = false;

    sops.age.sshKeyPaths = ["/persist/etc/ssh/ssh_host_ed25519_key"];

    boot.initrd.systemd = {
      services.wipe-btrfs = {
        unitConfig.DefaultDependencies = false;
        serviceConfig.Type = "oneshot";
        requiredBy = ["initrd.target"];
        before = ["sysroot.mount"];

        requires = ["${utils.escapeSystemdPath "/dev/mapper/cryptroot"}.device"];
        after = [
          "${utils.escapeSystemdPath "/dev/mapper/cryptroot"}.device"
          "local-fs-pre.target"
        ];

        script = ''
          MOUNTDIR=/btrfs_tmp

          echo 'Mount'
          mkdir -p $MOUNTDIR
          mount /dev/mapper/cryptroot -o user_subvol_rm_allowed $MOUNTDIR

          echo 'Moving root subvolume'
          mkdir -p $MOUNTDIR/previous_roots
          timestamp=$(date --date=@$(stat -c %Y $MOUNTDIR/root) "+%Y%m%d%H%M%S")
          mv $MOUNTDIR/root $MOUNTDIR/previous_roots/$timestamp

          echo 'Removing previous subvolumes'
          for previous_subvolume in $(find $MOUNTDIR/old_roots/ -mindepth 1 -maxdepth 1 -mtime +30); do
            echo "Removing $previous_subvolume"
            btrfs subvolume delete -R "$previous_subvolume"
          done

          echo 'Create new subvolume'
          btrfs subvolume create $MOUNTDIR/root
          umount $MOUNTDIR

          echo 'Continue boot'
        '';
      };
    };

    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/nixos"
      ];
      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];
    };
  };
}
