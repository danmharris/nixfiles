{pkgs, ...}: {
  home-manager = {
    users.dan.imports = [
      ../home/dan
    ];
  };
}
