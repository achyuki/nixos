{ inputs, ... }:
{
  imports = with inputs; [
    niri.homeModules.niri
    noctalia.homeModules.default
    ./niri
    ./noctalia.nix
  ];
}
