{
  config,
  lib,
  ...
}: let
  cfg = config.mySystem.prometheus;
in {
  options.mySystem.prometheus.enable = lib.mkEnableOption "prometheus";

  config = lib.mkIf (cfg.enable) {
    services.prometheus = {
      enable = true;

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
    };

    services.caddy.virtualHosts."prometheus.dnhrrs.xyz" = {
      useACMEHost = "dnhrrs.xyz";
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString config.services.prometheus.port}
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
