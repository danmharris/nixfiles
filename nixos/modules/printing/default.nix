{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mySystem.printing;
in {
  options.mySystem.printing.enable = lib.mkEnableOption "printing";

  config = lib.mkIf (cfg.enable) {
    services.printing = {
      enable = true;
      drivers = with pkgs; [
        cups-brother-hll2350dw
      ];
    };
  };
}
