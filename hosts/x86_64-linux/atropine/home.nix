{ pkgs, ... }:
{
  home.packages = with pkgs; [
    
  ];
  pref.persistent = [
    "Pictures/wallpaper"
    "Pictures/avatar.webp"
    ".config/nvim"
    ".config/DankMaterialShell"
    ".config/niri/dms/binds.kdl"
    ".config/niri/dms/windowrules.kdl"
    ".config/qt6ct/qt6ct.conf"
    ".config/kdeglobals"
    ".config/fcitx5"
    ".config/kitty"
  ];
}
