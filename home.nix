{ config, pkgs, ... }:

{
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
    fluxcd
    kubectl
    neovim
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/dan/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  catppuccin.flavor = "macchiato";

  fonts.fontconfig.enable = true;

  programs.git = {
    enable = true;
    signing = {
      key = "17D17AD6334D759997602A43E813BA5D01FAD970";
      signByDefault = true;
    };
    userEmail = "danharris1606@gmail.com";
    userName = "Dan Harris";
  };

  programs.starship = {
    enable = true;
    settings = {
      line_break = {
        disabled = true;
      };
    };
  };

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    mouse = true;
    terminal = "xterm-256color";
    catppuccin.enable = true;
    extraConfig = ''
      set-option -ga terminal-overrides ",xterm-256color:Tc"
      set-option -g renumber-windows on
      set -g allow-rename off
    '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    envExtra = ''
      export N_PREFIX=$HOME/.n

      typeset -U path PATH
      path=($N_PREFIX/bin $HOME/go/bin $HOME/bin $HOME/.local/bin $path)

      export PATH
    '';
    history = {
      append = true;
      expireDuplicatesFirst = true;
      extended = true;
      ignoreAllDups = true;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };
    initExtra = builtins.readFile ./files/init-extra.zsh;
  };

  programs.fzf.enable = true;
  programs.ripgrep.enable = true;

  xdg.configFile."alacritty/alacritty.toml" = {
    source = ./files/alacritty.toml;
  };

  xdg.configFile."alacritty/catppuccin-macchiato.toml" = {
    source = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "alacritty";
      rev = "f6cb5a5c2b404cdaceaff193b9c52317f62c62f7";
      hash = "sha256-H8bouVCS46h0DgQ+oYY8JitahQDj0V9p2cOoD4cQX+Q=";
    } + "/catppuccin-macchiato.toml";
  };

  xdg.configFile."nvim/" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/files/nvim";
    recursive = true;
  };
}
