{
  config,
  lib,
  ...
}: let
  cfg = config.mySystem.grafana;
in {
  options.mySystem.grafana.enable = lib.mkEnableOption "grafana";

  config = lib.mkIf (cfg.enable) {
    sops.secrets = let
      config = {
        sopsFile = ./secrets.sops.yml;
        owner = "grafana";
        group = "grafana";
      };
    in {
      "app/grafana/secret_key" = config;
      "app/grafana/admin_password" = config;
      "app/grafana/client_secret" = config;
    };

    services.grafana = {
      enable = true;
      settings = {
        server.root_url = "https://grafana.dnhrrs.xyz";

        database = {
          type = "postgres";
          host = "/run/postgresql";
          user = "grafana";
          name = "grafana";
        };

        security = {
          secret_key = "$__file{${config.sops.secrets."app/grafana/secret_key".path}}";
          admin_user = "admin";
          admin_password = "$__file{${config.sops.secrets."app/grafana/admin_password".path}}";
        };

        "auth.generic_oauth" = {
          enabled = true;
          name = "authentik";
          scopes = "openid profile email entitlements";
          client_id = "IJCVxwJY3AYgZGXWCFYs6gpneNoul4T5bN0kE71e";
          client_secret = "$__file{${config.sops.secrets."app/grafana/client_secret".path}}";
          auth_url = "https://authentik.dnhrrs.xyz/application/o/authorize/";
          api_url = "https://authentik.dnhrrs.xyz/application/o/userinfo/";
          token_url = "https://authentik.dnhrrs.xyz/application/o/token/";
          role_attribute_path = "contains(entitlements[*], 'Grafana Admins') && 'Admin' || contains(entitlements[*], 'Grafana Editors') && 'Editor' || 'Viewer'";
        };
      };

      provision.datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          access = "proxy";
          url = "http://localhost:${toString config.services.prometheus.port}";
          isDefault = true;
          jsonData.timeInterval = "1m";
        }
      ];
    };

    services.caddy.virtualHosts."grafana.dnhrrs.xyz" = {
      useACMEHost = "dnhrrs.xyz";
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}
      '';
    };

    services.postgresql = {
      enable = true;
      ensureUsers = [
        {
          name = "grafana";
          ensureDBOwnership = true;
        }
      ];
      ensureDatabases = ["grafana"];
    };

    environment.persistence."/persist" = lib.mkIf (config.mySystem.impermanence.enable) {
      directories = [
        {
          directory = config.services.grafana.dataDir;
          user = "grafana";
          group = "grafana";
          mode = "0755";
        }
      ];
    };

    mySystem.postgresql.backupDatabases = ["grafana"];
  };
}
