{pkgs, ...}: {
  users.users.dan = {
    packages = with pkgs; [
      discord
      mumble
    ];
  };
}
