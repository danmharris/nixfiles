{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHome.zsh;
in {
  options.myHome.zsh.enable = lib.mkEnableOption "zsh";

  config = lib.mkIf (cfg.enable) {
    home.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];

    programs.starship = {
      enable = true;
      settings = {
        line_break = {
          disabled = true;
        };
      };
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      envExtra = ''
        export N_PREFIX=$HOME/.n

        typeset -U path PATH
        path=($N_PREFIX/bin $HOME/go/bin $HOME/bin $HOME/.local/bin $path)

        export PATH
      '';
      history = {
        append = true;
        expireDuplicatesFirst = true;
        extended = true;
        ignoreAllDups = true;
        ignoreDups = true;
        ignoreSpace = true;
        share = true;
      };
      initContent = builtins.readFile ./init-extra.zsh;
    };

    programs.fzf.enable = true;
    programs.ripgrep.enable = true;
  };
}
