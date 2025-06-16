{
  config,
  lib,
  ...
}: let
  cfg = config.myHome.alacritty;
in {
  options.myHome.alacritty.enable = lib.mkEnableOption "alacritty";

  config = lib.mkIf (cfg.enable) {
    catppuccin.alacritty.enable = true;

    programs.alacritty = {
      enable = true;
      settings = {
        env = {
          TERM = "xterm-256color";
        };
        font = {
          size = 12.0;
          normal.family = "JetBrainsMono NF";
        };
        window = {
          decorations = "full";
        };
      };
    };
  };
}
