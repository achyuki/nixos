{ inputs, ... }:
{
  imports = with inputs;[
    dms.homeModules.dank-material-shell
    ./niri.nix
    ./dms.nix
    ./theme.nix

    ../components/dolphin.nix
    ../components/sysapps.nix
    ../components/kitty.nix
    ../components/fcitx5.nix
    ../components/shell.nix
    ../components/flatpak.nix
    ../components/portal.nix
  ];
}
