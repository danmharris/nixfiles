{
  config,
  lib,
  ...
}: let
  cfg = config.mySystem.prometheus;
in {
  options.mySystem.prometheus.enable = lib.mkEnableOption "prometheus";

  config = lib.mkIf (cfg.enable) {
    sops.secrets."app/alertmanager/env" = {
      sopsFile = ./secrets.sops.yml;
    };

    services.prometheus = {
      enable = true;
      webExternalUrl = "https://prometheus.dnhrrs.xyz";

      exporters = {
        node = {
          enable = true;
          enabledCollectors = ["systemd"];
        };
      };

      ruleFiles = [
        ./rules/prometheus.yml
        ./rules/node-exporter.yml
      ];

      scrapeConfigs = [
        {
          job_name = "prometheus";
          static_configs = [
            {targets = ["localhost:${toString config.services.prometheus.port}"];}
          ];
        }
        {
          job_name = "node";
          static_configs = [
            {targets = ["localhost:${toString config.services.prometheus.exporters.node.port}"];}
          ];
        }
      ];

      alertmanagers = [
        {
          static_configs = [
            {targets = ["localhost:${toString config.services.prometheus.alertmanager.port}"];}
          ];
        }
      ];

      alertmanager = {
        enable = true;
        environmentFile = config.sops.secrets."app/alertmanager/env".path;
        webExternalUrl = "https://alertmanager.dnhrrs.xyz";

        configuration = {
          receivers = [
            {
              name = "pushover";
              pushover_configs = [
                {
                  user_key = "$PUSHOVER_USER_KEY";
                  token = "$PUSHOVER_TOKEN";
                  priority = "{{ if eq .Status \"firing\" }}1{{ else }}0{{ end }}";
                }
              ];
            }
            {
              name = "sinkhole";
            }
          ];

          route = {
            group_by = ["alertname" "instance"];
            group_wait = "1m";
            group_interval = "5m";
            repeat_interval = "12h";
            receiver = "pushover";
            routes = [
              {
                matchers = ["alertname = PrometheusAlertManagerE2EDeadManSwitch"];
                receiver = "sinkhole";
              }
            ];
          };
        };
      };
    };

    services.caddy.virtualHosts."prometheus.dnhrrs.xyz" = {
      useACMEHost = "dnhrrs.xyz";
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString config.services.prometheus.port}
      '';
    };

    services.caddy.virtualHosts."alertmanager.dnhrrs.xyz" = {
      useACMEHost = "dnhrrs.xyz";
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString config.services.prometheus.alertmanager.port}
      '';
    };

    environment.persistence."/persist" = lib.mkIf (config.mySystem.impermanence.enable) {
      directories = [
        {
          directory = "/var/lib/prometheus2";
          user = "prometheus";
          group = "prometheus";
          mode = "0700";
        }
      ];
    };
  };
}
