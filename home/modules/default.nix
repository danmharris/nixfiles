{
  config,
  lib,
  ...
}: {
  imports = [
    ./_base

    ./alacritty
    ./ghostty
    ./git
    ./gpg
    ./nvim
    ./tmux
    ./zsh
  ];

  options.myHome.nixfilesPath = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/nixfiles";
  };
}
