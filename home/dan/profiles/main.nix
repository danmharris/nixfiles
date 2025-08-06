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

  programs.ssh.enable = true;
  programs.ssh.matchBlocks.cisco = {
    host = "switch0.dnhrrs.xyz";
    user = "cisco";
    extraOptions = {
      KexAlgorithms = "+diffie-hellman-group-exchange-sha1";
      HostKeyAlgorithms = "+ssh-rsa";
    };
  };
}
