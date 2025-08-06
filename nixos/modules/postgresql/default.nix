{
  config,
  lib,
  ...
}: let
  cfg = config.mySystem.postgresql;
in {
  options.mySystem.postgresql.backupDatabases = lib.mkOption {
    type = lib.types.listOf lib.types.str;
  };

  config = lib.mkIf (config.services.postgresql.enable) {
    services.postgresqlBackup = {
      enable = true;
      backupAll = false;
      databases = cfg.backupDatabases;
    };

    environment.persistence."/nix/persist" = lib.mkIf (config.mySystem.impermanence.enable) {
      directories = [
        {
          directory = config.services.postgresql.dataDir;
          user = "postgres";
          group = "postgres";
          mode = "0750";
        }
        {
          directory = config.services.postgresqlBackup.location;
          user = "postgres";
          group = "postgres";
          mode = "0750";
        }
      ];
    };

    mySystem.restic.backups.postgresql = {
      paths = [
        config.services.postgresqlBackup.location
      ];
    };
  };
}
