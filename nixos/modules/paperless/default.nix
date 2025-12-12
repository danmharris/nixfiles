{
  config,
  lib,
  pkgs-unstable,
  ...
}: let
  cfg = config.mySystem.paperless;
in {
  options.mySystem.paperless.enable = lib.mkEnableOption "paperless";

  config = lib.mkIf (cfg.enable) {
    sops.secrets = {
      "app/paperless/env" = {
        sopsFile = ./secrets.sops.yml;
      };
      "app/paperless/password" = {
        sopsFile = ./secrets.sops.yml;
      };
    };

    services.paperless = {
      enable = true;
      database.createLocally = true;
      settings = {
        PAPERLESS_URL = "https://paperless.dnhrrs.xyz";
        PAPERLESS_TIME_ZONE = "Europe/London";
        PAPERLESS_ACCOUNT_EMAIL_VERIFICATION = "none";
        PAPERLESS_APPS = "allauth.socialaccount.providers.openid_connect";
        PAPERLESS_AUTO_SIGNUP = "true";
        PAPERLESS_OCR_USER_ARGS = "{\"invalidate_digital_signatures\": true}";
      };
      passwordFile = config.sops.secrets."app/paperless/password".path;
      environmentFile = config.sops.secrets."app/paperless/env".path;
    };

    mySystem.caddy.enable = true;
    services.caddy.virtualHosts."paperless.dnhrrs.xyz" = {
      useACMEHost = "dnhrrs.xyz";
      extraConfig = ''
        reverse_proxy http://${config.services.paperless.address}:${toString config.services.paperless.port}
      '';
    };

    environment.persistence."/persist" = lib.mkIf (config.mySystem.impermanence.enable) {
      directories = [
        {
          directory = config.services.paperless.dataDir;
          user = config.services.paperless.user;
          group = config.services.paperless.user;
        }
      ];
    };

    mySystem.postgresql.backupDatabases = ["paperless"];
    mySystem.restic.backups.paperless = {
      paths = [
        config.services.paperless.dataDir
      ];
    };
  };
}
