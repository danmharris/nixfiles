{
  config,
  lib,
  ...
}: let
  cfg = config.myHome.git;
in {
  options.myHome.git = {
    enable = lib.mkEnableOption "git";
    signing.enable = lib.mkEnableOption "git signing";
  };

  config = lib.mkIf (cfg.enable) {
    programs.git = {
      enable = true;
      settings.user = {
        email = "danharris1606@gmail.com";
        name = "Dan Harris";
      };
    };
  };
}
