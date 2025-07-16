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

    services.restic.backups = lib.mapAttrs (name: backupConfig:
      {
        repository = "/mnt/restic/${name}";
        initialize = true;
        passwordFile = config.sops.secrets."services/restic/password".path;
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
          RandomizedDelaySec = "30m";
        };
        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 4"
          "--keep-monthly 3"
        ];
      }
      // backupConfig)
    cfg.backups;
  };
}
