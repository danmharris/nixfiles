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
        theme = "catppuccin-macchiato";
        font-size = 12;
      };
    };
  };
}
