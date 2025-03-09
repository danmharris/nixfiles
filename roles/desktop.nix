{ nixpkgs, ... }: {
    imports = [
      ./gnome.nix
      ./dev-terminal.nix
      ./gaming.nix
      ./chat.nix
    ];
}
