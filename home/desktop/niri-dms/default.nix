{ inputs, ... }:
{
  imports = with inputs;[
    niri.homeModules.niri
    dms.homeModules.dank-material-shell
    dms.homeModules.niri
    ./niri.nix
    ./dms.nix
    ./theme.nix

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
