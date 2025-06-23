{pkgs, ...}: {
  home.packages = with pkgs; [
    spotify
    libreoffice
    hunspell
    hunspellDicts.en_GB-ise
    discord
    mumble
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.firefox.enable = true;

  myHome = {
    alacritty.enable = true;
    ghostty.enable = true;
    git.enable = true;
    gpg.enable = true;
    nvim.enable = true;
    tmux.enable = true;
    zsh.enable = true;
  };
}
