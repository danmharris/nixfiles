{
  config,
  lib,
  ...
}: let
  cfg = config.mySystem.sonarr;
in {
  options.mySystem.sonarr.enable = lib.mkEnableOption "sonarr";

  config = lib.mkIf (cfg.enable) {
    mySystem.nas.mounts.media = {
      enable = true;
      groupExtraUsers = [config.services.sonarr.user];
    };

    services.sonarr = {
      enable = true;
    };

    mySystem.caddy.enable = true;
    services.caddy.virtualHosts."sonarr.dnhrrs.xyz" = {
      useACMEHost = "dnhrrs.xyz";
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString config.services.sonarr.settings.server.port}
      '';
    };

    environment.persistence."/persist" = lib.mkIf (config.mySystem.impermanence.enable) {
      directories = [
        {
          directory = "/var/lib/sonarr";
          user = config.services.sonarr.user;
          group = config.services.sonarr.group;
          mode = "0755";
        }
      ];
    };

    mySystem.restic.backups.sonarr = {
      paths = [
        "/var/lib/sonarr"
      ];
    };
  };
}
