{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # GNOME
    showtime loupe decibels
    gnome-software seahorse

    # KDE
    kdePackages.ark
    kdePackages.filelight

    # Other
    mission-center gparted
  ];
}
