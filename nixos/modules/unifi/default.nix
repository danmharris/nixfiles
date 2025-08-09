{
  config,
  lib,
  ...
}: let
  cfg = config.mySystem.unifi;
  dataDir = "/var/lib/unifi";
in {
  options.mySystem.unifi.enable = lib.mkEnableOption "unifi";

  config = lib.mkIf (cfg.enable) {
    services.unifi = {
      enable = true;
      openFirewall = true;
    };

    networking.firewall.allowedTCPPorts = [
      8443
    ];

    environment.persistence."/persist" = lib.mkIf (config.mySystem.impermanence.enable) {
      directories = [
        {
          directory = dataDir;
          user = "unifi";
          group = "unifi";
          mode = "0755";
        }
      ];
    };

    mySystem.restic.backups.unifi = {
      paths = [
        dataDir
      ];
    };
  };
}
