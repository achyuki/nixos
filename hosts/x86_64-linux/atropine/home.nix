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
    ".config/dms/.firstlaunch"
    ".config/dms/settings.json"
    ".config/dms/plugin_settings.json"
    ".config/dms/clsettings.json"
    ".config/niri/dms/binds.kdl"
    ".config/niri/dms/windowrules.kdl"
    ".config/qt6ct/qt6ct.conf"
    ".config/kdeglobals"
    ".config/fcitx5"
    ".config/kitty"
    "scripts"
  ];
}
