{pkgs, ...}: {
  home.packages = with pkgs; [
    spotify
  ];

  programs.firefox.enable = true;

  myHome = {
    ghostty.enable = true;
    git.enable = true;
    zsh.enable = true;
  };
}
