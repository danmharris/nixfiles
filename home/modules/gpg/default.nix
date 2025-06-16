{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHome.gpg;
in {
  options.myHome.gpg.enable = lib.mkEnableOption "gpg";

  config = lib.mkIf (cfg.enable) {
    programs.gpg.enable = true;
    services.gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-curses;
    };

    programs.git.signing = {
      key = "17D17AD6334D759997602A43E813BA5D01FAD970";
      signByDefault = true;
    };
  };
}
