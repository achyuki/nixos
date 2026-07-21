{ config, pkgs, modules, ... }:
{
  home.packages = with pkgs; [
  ];
  pref.persistent = [
    "Pictures/wallpaper"
    "Pictures/avatar.webp"
    ".config/nvim"
    ".config/DankMaterialShell"
    ".config/qt5ct/qt5ct.conf"
    ".config/qt6ct/qt6ct.conf"
    ".config/kitty"
    ".config/dolphinrc"
  ];

}
