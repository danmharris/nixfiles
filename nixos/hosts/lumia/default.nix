{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  environment.systemPackages = with pkgs; [
    pciutils
    powertop
  ];

  powerManagement.powertop.enable = true;

  networking.useDHCP = false;
  systemd.network = {
    enable = true;
    netdevs = {
      "10-vlan30" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan30";
        };
        vlanConfig.Id = 30;
      };
    };

    networks = {
      "10-enp2s0" = {
        matchConfig.Name = "enp2s0";
        networkConfig.DHCP = true;
        vlan = [
          "vlan30"
        ];
      };
      "20-vlan30" = {
        matchConfig.Name = "vlan30";
        networkConfig.DHCP = true;
      };
    };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
      vpl-gpu-rt
    ];
  };

  mySystem = {
    acme.enable = true;
    glances.enable = true;
    immich.enable = true;
    jellyfin.enable = true;
    linkding.enable = true;
    restic.enable = true;
    impermanence.enable = true;
    cryptroot.enable = true;
    unifi.enable = true;
    paperless.enable = true;
    authentik.enable = true;
    mealie.enable = true;
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
