{ inputs, pkgs, ... }:
{
  imports = with inputs; [
    niri.homeModules.niri
    dms.homeModules.dank-material-shell
    dms.homeModules.niri
    ./niri.nix
    ./dms.nix
  ];
}
