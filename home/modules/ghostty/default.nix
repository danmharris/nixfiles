{
  config,
  lib,
  ...
}: let
  cfg = config.myHome.ghostty;
in {
  options.myHome.ghostty.enable = lib.mkEnableOption "ghostty";

  config = lib.mkIf (cfg.enable) {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        theme = "Catppuccin Macchiato";
        font-size = 12;
      };
    };
  };
}
