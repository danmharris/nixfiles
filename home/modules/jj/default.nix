{
  config,
  lib,
  ...
}: let
  cfg = config.myHome.jj;
in {
  options.myHome.jj.enable = lib.mkEnableOption "jujutsu";

  config = lib.mkIf (cfg.enable) {
    programs.jujutsu = {
      enable = true;
      settings.user = {
        email = "me@danmharris.com";
        name = "Dan Harris";
      };
    };
  };
}
