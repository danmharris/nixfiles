{
  config,
  lib,
  ...
}: let
  cfg = config.mySystem.immich;
in {
  options.mySystem.immich.enable = lib.mkEnableOption "immich";

  config = lib.mkIf (cfg.enable) {
    services.immich = {
      enable = true;
      port = 2283;
      host = "localhost";
      mediaLocation = "/var/lib/immich";
    };

    mySystem.caddy.enable = true;
    services.caddy.virtualHosts."immich.dnhrrs.xyz" = {
      useACMEHost = "dnhrrs.xyz";
      extraConfig = ''
        reverse_proxy http://${config.services.immich.host}:${toString config.services.immich.port}
      '';
    };

    environment.persistence."/persist" = lib.mkIf (config.mySystem.impermanence.enable) {
      directories = [
        {
          directory = config.services.immich.mediaLocation;
          user = "immich";
          group = "immich";
          mode = "0750";
        }
      ];
    };

    mySystem.restic.backups.immich = {
      paths = [
        config.services.immich.mediaLocation
      ];
    };
  };
}
