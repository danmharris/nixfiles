{
  config,
  lib,
  ...
}: let
  cfg = config.mySystem.restic;
in {
  options.mySystem.restic = {
    enable = lib.mkEnableOption "restic";
    backups = lib.mkOption {
      type = lib.types.attrs;
    };
  };

  config = lib.mkIf (cfg.enable) {
    fileSystems."/mnt/restic" = {
      device = "nas.dnhrrs.xyz:/volume1/restic";
      fsType = "nfs";
    };

    sops.secrets."services/restic/password" = {
      sopsFile = ./secrets.sops.yml;
    };

    services.restic.backups =
      (lib.mapAttrs (name: backupConfig:
        {
          repository = "/mnt/restic/apps";
          initialize = false;
          createWrapper = false;
          passwordFile = config.sops.secrets."services/restic/password".path;
          timerConfig = {
            OnCalendar = "daily";
            Persistent = true;
            RandomizedDelaySec = "30m";
          };
          runCheck = false;
          extraBackupArgs = [
            "--group-by host,tags"
            "--tag ${name}"
          ];
        }
        // backupConfig)
      cfg.backups)
      // {
        apps = {
          repository = "/mnt/restic/apps";
          initialize = true;
          passwordFile = config.sops.secrets."services/restic/password".path;
          timerConfig = {
            OnCalendar = "*-*-* 4:00:00";
            Persistent = true;
            RandomizedDelaySec = "5m";
          };
          pruneOpts = [
            "--group-by host,tags"
            "--keep-within-daily 7d"
            "--keep-within-weekly 1m"
            "--keep-within-monthly 6m"
          ];
        };
      };
  };
}
