{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
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

  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
  };

  myHome = {
    ghostty.enable = true;
    git.enable = true;
    gpg.enable = true;
    jj.enable = true;
    nvim.enable = true;
    tmux.enable = true;
    zsh.enable = true;
  };

  programs.ssh.enable = true;
}
