{
  config,
  lib,
  ...
}: let
  cfg = config.mySystem.nas.mounts.media;
in {
  options.mySystem.nas.mounts.media = {
    enable = lib.mkEnableOption "media share";
    groupExtraUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };
  };

  config = lib.mkIf (cfg.enable) {
    users.groups.media = {
      gid = 65538;
      members = ["dan"] ++ cfg.groupExtraUsers;
    };

    fileSystems = {
      "/mnt/media" = {
        device = "nas.dnhrrs.xyz:/volume1/media";
        fsType = "nfs";
      };
    };
  };
}
