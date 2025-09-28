{
  config,
  lib,
  ...
}: let
  cfg = config.mySystem.mealie;
in {
  options.mySystem.mealie.enable = lib.mkEnableOption "mealie";

  config = lib.mkIf (cfg.enable) {
    sops.secrets."app/mealie/env" = {
      sopsFile = ./secrets.sops.yml;
    };

    services.mealie = {
      enable = true;
      settings = {
        MAX_WORKERS = "1";
        WEB_CONCURRENCY = "1";
        BASE_URL = "https://mealie.dnhrrs.xyz";
        OIDC_AUTH_ENABLED = "true";
        OIDC_CONFIGURATION_URL = "https://authentik.dnhrrs.xyz/application/o/mealie/.well-known/openid-configuration";
        OIDC_PROVIDER_NAME = "Authentik";
        OIDC_CLIENT_ID = "gM3QLLxkb3NBs4xSqzOxP7uKbKFdLeOimLPerd0y";
      };
      credentialsFile = config.sops.secrets."app/mealie/env".path;
      database.createLocally = true;
      listenAddress = "127.0.0.1";
      port = 9010;
    };

    mySystem.caddy.enable = true;
    services.caddy.virtualHosts."mealie.dnhrrs.xyz" = {
      useACMEHost = "dnhrrs.xyz";
      extraConfig = ''
        reverse_proxy http://${config.services.mealie.listenAddress}:${toString config.services.mealie.port}
      '';
    };

    environment.persistence."/persist" = lib.mkIf (config.mySystem.impermanence.enable) {
      directories = [
        {
          directory = "/var/lib/private/mealie";
          user = "nobody";
          group = "nogroup";
          mode = "0755";
        }
      ];
    };

    mySystem.postgresql.backupDatabases = ["mealie"];
    mySystem.restic.backups.mealie = {
      paths = ["/var/lib/private/mealie"];
    };
  };
}
