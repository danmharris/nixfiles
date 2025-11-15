{
  config,
  pkgs,
  lib,
  hostname,
  ...
}: {
  networking = {
    domain = "dnhrrs.xyz";
    hostName = hostname;
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      trusted-users = ["@wheel"];

      substituters = [
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  system.activationScripts.diff = ''
    PATH=$PATH:${lib.makeBinPath [pkgs.nvd pkgs.nix]}
    nvd diff $(ls -dv /nix/var/nix/profiles/system-*-link | tail -2)
  '';

  system.autoUpgrade = {
    enable = true;
    flake = "github:danmharris/nixfiles";
  };

  sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  powerManagement.enable = true;

  sops.secrets.dan-password = {
    sopsFile = ./secrets.sops.yml;
    neededForUsers = true;
  };

  users.users.dan = {
    isNormalUser = true;
    description = "Dan Harris";
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
    hashedPasswordFile = config.sops.secrets.dan-password.path;

    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4div1SWpMioi2ibOZy3/ww3tN8rdoNE5RLiy90s7leQsBhe8LzFVw8kn+oMVFIa/QBc8Iwt19j774OtG/wtfN3lNwO+s2N36ha34z722adfTB9LouEv0Af+sHvvrcVAMgNZ8Lqtevjy1VgLOx/LGMTi3pFhk7FfVFPwmYmPEXY+PjxPH8vALDgLMtTqt0o7OtuGI1ekXQ6V/7sXITiLVBzkGxmeYMOZZwNiVNNC0FdcFAopueZKzaejTLgmD/0Y1MGitDZSw+t0oAS2Rry152xSjcWaisdKJeO9F7r09rAr1oWwSttDAa99ddYcfv/gmkFz5kgr6uOPvPlp64gu5T"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOkFBua9e2PT5pUZSi9fpRYznYepQBuNcTMj97gupNfB"
    ];
  };

  programs = {
    zsh.enable = true;
    git.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nvd
    vim
    wget
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
