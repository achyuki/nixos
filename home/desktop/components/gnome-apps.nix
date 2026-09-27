{ pkgs, ... }:
{
  home.packages = with pkgs; [
    showtime loupe decibels
    gnome-software file-roller seahorse
  ];
}
