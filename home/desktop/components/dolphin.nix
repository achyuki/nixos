{ pkgs, ... }:
{
  home.packages = with pkgs;
  with kdePackages; [
    dolphin
    kio
    #kio-admin
    kio-extras
    kio-fuse
  ];
}
