{
  config,
  lib,
  ...
}: let
  cfg = config.mySystem.nas.mounts.photos;
in {
  options.mySystem.nas.mounts.photos = {
    enable = lib.mkEnableOption "photos share";
    groupExtraUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };
  };

  config = lib.mkIf (cfg.enable) {
    users.groups.photos = {
      gid = 65539;
      members = ["dan"] ++ cfg.groupExtraUsers;
    };

    fileSystems = {
      "/mnt/photos" = {
        device = "nas.dnhrrs.xyz:/volume1/Photos";
        fsType = "nfs";
      };
    };
  };
}
