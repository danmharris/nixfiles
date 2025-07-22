{
  config,
  lib,
  ...
}: let
  cfg = config.mySystem.nas.mounts.media;
in {
  options.mySystem.nas.mounts.media = {
    enable = lib.mkEnableOption "tv and movies share";
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
      "/mnt/media/movies" = {
        device = "nas.dnhrrs.xyz:/volume1/Movies";
        fsType = "nfs";
      };

      "/mnt/media/tv" = {
        device = "nas.dnhrrs.xyz:/volume1/TV Shows";
        fsType = "nfs";
      };
    };
  };
}
