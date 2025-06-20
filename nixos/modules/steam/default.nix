{
  config,
  lib,
  ...
}: let
  cfg = config.mySystem.steam;
in {
  options.mySystem.steam.enable = lib.mkEnableOption "steam";

  config = lib.mkIf (cfg.enable) {
    programs.steam = {
      enable = true;
      protontricks.enable = true;
      remotePlay.openFirewall = true;
    };
  };
}
