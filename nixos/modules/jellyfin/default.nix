{
  config,
  lib,
  ...
}: let
  cfg = config.mySystem.jellyfin;
in {
  options.mySystem.jellyfin.enable = lib.mkEnableOption "jellyfin";

  config = lib.mkIf (cfg.enable) {
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

    services.jellyfin = {
      enable = true;
    };

    mySystem.caddy.enable = true;
    services.caddy.virtualHosts."jellyfin.dnhrrs.xyz" = {
      useACMEHost = "dnhrrs.xyz";
      extraConfig = ''
        reverse_proxy http://127.0.0.1:8096
      '';
    };

    environment.persistence."/nix/persist" = lib.mkIf (config.mySystem.impermanence.enable) {
      directories = [
        {
          directory = config.services.jellyfin.dataDir;
          user = config.services.jellyfin.user;
          group = config.services.jellyfin.group;
          mode = "0755";
        }
      ];
    };

    mySystem.restic.backups.jellyfin = {
      paths = [
        config.services.jellyfin.dataDir
      ];
    };
  };
}
