{ pkgs, ... }:
{
  home.packages = with pkgs; [
    
  ];
  pref.persistent = [
    "Pictures/wallpaper"
    "Pictures/avatar.webp"
    ".config/nvim"
    ".config/DankMaterialShell"
    ".config/qt6ct/qt6ct.conf"
    ".config/kdeglobals"
    ".config/kitty"
  ];
}
