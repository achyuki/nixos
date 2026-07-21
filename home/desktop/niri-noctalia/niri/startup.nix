{ pkgs, ... }:
{
  programs.niri.settings.spawn-at-startup = [
    { command = [ "noctalia-shell" ]; }
    { command = [ "${pkgs.xwayland-satellite}/bin/xwayland-satellite" ]; }
  ];
}
