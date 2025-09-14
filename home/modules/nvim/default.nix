{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHome.nvim;
in {
  options.myHome.nvim.enable = lib.mkEnableOption "nvim";

  config = lib.mkIf (cfg.enable) {
    home.packages = with pkgs; [
      nil
    ];

    programs.nixvim =
      import ./config {inherit pkgs lib config;}
      // {
        enable = true;
      };

    home.sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
