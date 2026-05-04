{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHome.gpg;
in {
  options.myHome.gpg.enable = lib.mkEnableOption "gpg";

  config = let
    key = "17D17AD6334D759997602A43E813BA5D01FAD970";
  in
    lib.mkIf (cfg.enable) {
      programs.gpg.enable = true;
      services.gpg-agent = {
        enable = true;
        pinentry.package = pkgs.pinentry-curses;
      };

      programs.git.signing = {
        inherit key;
        signByDefault = true;
      };

      programs.jujutsu.settings = {
        signing = {
          inherit key;
          backend = "gpg";
          behaviour = "own";
        };

        git.sign-on-push = true;
      };
    };
}
