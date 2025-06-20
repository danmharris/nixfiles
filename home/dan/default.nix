{pkgs, ...}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "dan";
  home.homeDirectory = "/home/dan";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    alejandra
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
