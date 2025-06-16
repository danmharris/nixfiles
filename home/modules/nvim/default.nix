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
      neovim
      nil
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    xdg.configFile."nvim/" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.myHome.nixfilesPath}/home/modules/nvim/config";
      recursive = true;
    };
  };
}
