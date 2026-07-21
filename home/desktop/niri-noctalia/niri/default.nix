_: {
  imports = [
    ./base.nix
    ./startup.nix
    ./keybinds.nix
    ./styles.nix
    ./rules.nix
  ];

  programs.niri.enable = true;
}
