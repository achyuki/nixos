{ pkgs, ... }:
{
  home.packages = [ pkgs.localsend ];
  services.kdeconnect.enable = true;
}
