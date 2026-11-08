{ pkgs, ... }:
{
  home.packages =
    with pkgs; 
    with localPkgs;
    [
      looking-glass-client-git
      uu-remote-linux
      flclash
      gpu-screen-recorder
      scrcpy

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
    ".local/bin/nvswitch"
  ];
  home.file = builtins.listToAttrs (map (n: {
    name = ".local/bin/${n}";
    value = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        export QT_IM_MODULE=fcitx
        exec /home/yuki/.nix-profile/bin/${n} "$@"
     '';
    };
  }) [ "wps" "et" "wpp" "wpspdf" ]);

}
