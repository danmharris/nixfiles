{
  config,
  lib,
  ...
}: let
  cfg = config.mySystem.sabnzbd;
in {
  options.mySystem.sabnzbd.enable = lib.mkEnableOption "sabnzbd";

  config = lib.mkIf (cfg.enable) {
    mySystem.nas.mounts.media = {
      enable = true;
      groupExtraUsers = [config.services.sabnzbd.user];
    };

    services.sabnzbd = {
      enable = true;
      allowConfigWrite = true;
    };

    mySystem.caddy.enable = true;
    services.caddy.virtualHosts."sabnzbd.dnhrrs.xyz" = {
      useACMEHost = "dnhrrs.xyz";
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString config.services.sabnzbd.settings.misc.port}
      '';
    };

    environment.persistence."/persist" = lib.mkIf (config.mySystem.impermanence.enable) {
      directories = [
        {
          directory = "/var/lib/${config.services.sabnzbd.stateDir}";
          user = config.services.sabnzbd.user;
          group = config.services.sabnzbd.group;
          mode = "0755";
        }
      ];
    };

    mySystem.restic.backups.sabnzbd = {
      paths = [
        "/var/lib/${config.services.sabnzbd.stateDir}"
      ];
    };
  };
}
