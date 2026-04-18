{
  config,
  lib,
  ...
}: let
  cfg = config.mySystem.vikunja;
in {
  options.mySystem.vikunja.enable = lib.mkEnableOption "vikunja";

  config = lib.mkIf (cfg.enable) {
    sops.secrets."app/vikunja/env" = {
      sopsFile = ./secrets.sops.yml;
    };

    services.vikunja = {
      enable = true;
      database = {
        type = "postgres";
        host = "/run/postgresql";
      };
      frontendHostname = "vikunja.dnhrrs.xyz";
      frontendScheme = "https";
      port = 3456;
      environmentFiles = [config.sops.secrets."app/vikunja/env".path];
      settings = {
        auth.openid = {
          enabled = true;
          providers.authentik = {
            name = "authentik";
            authurl = "https://authentik.dnhrrs.xyz/application/o/vikunja/";
            logouturl = "https://authentik.dnhrrs.xyz/application/o/vikunja/end-session/";
            clientid = "daaGV3bNAsOAiwlXaRuhEm6zaEpO3vUzEGk2ayYd";
          };
        };
      };
    };

    services.caddy.virtualHosts."vikunja.dnhrrs.xyz" = {
      useACMEHost = "dnhrrs.xyz";
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString config.services.vikunja.port}
      '';
    };

    services.postgresql = {
      enable = true;
      ensureUsers = [
        {
          name = "vikunja";
          ensureDBOwnership = true;
        }
      ];
      ensureDatabases = ["vikunja"];
    };

    environment.persistence."/persist" = lib.mkIf (config.mySystem.impermanence.enable) {
      directories = [
        {
          directory = "/var/lib/private/vikunja";
          user = "nobody";
          group = "nogroup";
          mode = "0755";
        }
      ];
    };

    mySystem.postgresql.backupDatabases = ["vikunja"];
    mySystem.restic.backups.vikunja = {
      paths = ["/var/lib/private/vikunja"];
    };
  };
}
