{ pkgs, ... }:
{
  home.packages = with pkgs; [
    localPkgs.looking-glass-client-git
    gpu-screen-recorder
    wayvnc
  ];
  home.sessionPath = [
    "$HOME/scripts"
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
    "scripts"
  ];
}
