{
  config,
  lib,
  ...
}: let
  cfg = config.mySystem.cryptroot;
in {
  options.mySystem.cryptroot.enable = lib.mkEnableOption "cryptroot";

  config = lib.mkIf (cfg.enable) {
    boot.kernelParams = ["ip=dhcp"];
    boot.initrd.network = {
      enable = true;
      ssh = {
        enable = true;
        port = 2222;
        authorizedKeys = builtins.map (k: ''command="systemctl default" ${k}'') config.users.users.dan.openssh.authorizedKeys.keys;
        hostKeys = ["/persist/initrd/ssh_host_ed25519_key"];
      };
    };
  };
}
