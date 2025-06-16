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
      terminal = "xterm-256color";
      extraConfig = ''
        set-option -ga terminal-overrides ",xterm-256color:Tc"
        set-option -g renumber-windows on
        set -g allow-rename off
      '';
    };
  };
}
