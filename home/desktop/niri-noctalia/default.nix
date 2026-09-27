{ inputs, ... }:
{
  imports = with inputs; [
    niri.homeModules.niri
    noctalia.homeModules.default
    ./niri
    ./noctalia.nix

    ../components/dolphin.nix
    ../components/gnome-apps.nix
    ../components/mission-center.nix
    ../components/kitty.nix
    ../components/fcitx5.nix
    ../components/shell.nix
    ../components/flatpak.nix
    ../components/portal.nix
  ];
}
