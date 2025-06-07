{pkgs, ...}: {
  programs.steam = {
    enable = true;
    protontricks.enable = true;
    remotePlay.openFirewall = true;
  };

  users.users.dan.packages = with pkgs; [
    prismlauncher
  ];
}
