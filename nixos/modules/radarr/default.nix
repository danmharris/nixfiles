{
  config,
  lib,
  ...
}: let
  cfg = config.mySystem.radarr;
in {
  options.mySystem.radarr.enable = lib.mkEnableOption "radarr";

  config = lib.mkIf (cfg.enable) {
    mySystem.nas.mounts.media = {
      enable = true;
      groupExtraUsers = [config.services.radarr.user];
    };

    services.radarr = {
      enable = true;
    };

    mySystem.caddy.enable = true;
    services.caddy.virtualHosts."radarr.dnhrrs.xyz" = {
      useACMEHost = "dnhrrs.xyz";
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString config.services.radarr.settings.server.port}
      '';
    };

    environment.persistence."/persist" = lib.mkIf (config.mySystem.impermanence.enable) {
      directories = [
        {
          directory = "/var/lib/radarr";
          user = config.services.radarr.user;
          group = config.services.radarr.group;
          mode = "0755";
        }
      ];
    };

    mySystem.restic.backups.radarr = {
      paths = [
        "/var/lib/radarr"
      ];
    };
  };
}
