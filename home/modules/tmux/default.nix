{
  config,
  lib,
  ...
}: let
  cfg = config.myHome.tmux;
in {
  options.myHome.tmux.enable = lib.mkEnableOption "tmux";

  config = lib.mkIf (cfg.enable) {
    catppuccin.tmux.enable = true;

    programs.tmux = {
      enable = true;
      baseIndex = 1;
      mouse = true;
      terminal = "tmux-256color";
      escapeTime = 10;
      focusEvents = true;
      extraConfig = ''
        set-option -g renumber-windows on
        set -g allow-rename off
      '';
    };
  };
}
