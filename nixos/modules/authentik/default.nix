{
  config,
  lib,
  ...
}: let
  cfg = config.mySystem.authentik;
in {
  options.mySystem.authentik.enable = lib.mkEnableOption "authentik";

  config = lib.mkIf (cfg.enable) {
    sops.secrets."app/authentik/env" = {
      sopsFile = ./secrets.sops.yml;
    };

    services.authentik = {
      enable = true;
      environmentFile = config.sops.secrets."app/authentik/env".path;
      createDatabase = true;
    };

    mySystem.caddy.enable = true;
    services.caddy.virtualHosts."authentik.dnhrrs.xyz" = {
      useACMEHost = "dnhrrs.xyz";
      extraConfig = ''
        reverse_proxy http://localhost:9000
      '';
    };

    mySystem.postgresql.backupDatabases = ["authentik"];
  };
}
