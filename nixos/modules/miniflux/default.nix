{
  config,
  lib,
  ...
}: let
  cfg = config.mySystem.miniflux;
in {
  options.mySystem.miniflux.enable = lib.mkEnableOption "miniflux";

  config = lib.mkIf (cfg.enable) {
    sops.secrets."app/miniflux/env" = {
      sopsFile = ./secrets.sops.yml;
    };

    services.miniflux = {
      enable = true;
      config = {
        LISTEN_ADDR = "localhost:8081";
        BASE_URL = "https://miniflux.dnhrrs.xyz";
        OAUTH2_PROVIDER = "oidc";
        OAUTH2_CLIENT_ID = "fuBd2TRZB4yhGsqDFAhGrTswTap2FuAHBtx816bp";
        OAUTH2_REDIRECT_URL = "https://miniflux.dnhrrs.xyz/oauth2/oidc/callback";
        OAUTH2_OIDC_DISCOVERY_ENDPOINT = "https://authentik.dnhrrs.xyz/application/o/miniflux/";
        OAUTH2_USER_CREATION = "1";
      };
      adminCredentialsFile = config.sops.secrets."app/miniflux/env".path;
      createDatabaseLocally = true;
    };

    mySystem.caddy.enable = true;
    services.caddy.virtualHosts."miniflux.dnhrrs.xyz" = {
      useACMEHost = "dnhrrs.xyz";
      extraConfig = ''
        reverse_proxy http://localhost:8081
      '';
    };

    mySystem.postgresql.backupDatabases = ["miniflux"];
  };
}
