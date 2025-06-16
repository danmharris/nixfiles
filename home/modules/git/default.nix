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
      userEmail = "danharris1606@gmail.com";
      userName = "Dan Harris";
    };
  };
}
