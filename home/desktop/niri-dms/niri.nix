{ pkgs, ... }:
{
  wayland.windowManager.niri = {
    enable = true;
    package = pkgs.niri;
    settings = {
      hotkey-overlay.skip-at-startup = { };
      gestures.hot-corners = {
        off = { };
      };
      prefer-no-csd = { };
      screenshot-path = "~/Pictures/Screenshots/Screenshot_%Y-%m-%d_%H-%M-%S.png";

      input = {
        #focus-follows-mouse = {};
        keyboard.numlock = { };
        touchpad = {
          tap = { };
          natural-scroll = { };
        };
      };
      environment = {
        DISPLAY = ":0";
        # https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland
        XMODIFIERS = "@im=fcitx";
        #GTK_IM_MODULE = "fcitx";
        QT_IM_MODULE = "fcitx";
        QT_QPA_PLATFORMTHEME = "qt6ct";
        LANG = "zh_CN.UTF-8";
        LC_MESSAGES = "zh_CN.UTF-8";
      };
      binds = {
        "Mod+E".spawn = "dolphin";
      };
      _children = [
        { include = { _props = { optional = true; }; _args = [ "dms/alttab.kdl" ]; }; }
        { include = { _props = { optional = true; }; _args = [ "dms/binds.kdl" ]; }; }
        { include = { _props = { optional = true; }; _args = [ "dms/colors.kdl" ]; }; }
        { include = { _props = { optional = true; }; _args = [ "dms/cursor.kdl" ]; }; }
        { include = { _props = { optional = true; }; _args = [ "dms/input.kdl" ]; }; }
        { include = { _props = { optional = true; }; _args = [ "dms/layout.kdl" ]; }; }
        { include = { _props = { optional = true; }; _args = [ "dms/outputs.kdl" ]; }; }
        { include = { _props = { optional = true; }; _args = [ "dms/windowrules.kdl" ]; }; }
        { include = { _props = { optional = true; }; _args = [ "dms/wpblur.kdl" ]; }; }

        { spawn-at-startup._args = [ "dms" "run" ]; }
      ];
    };
  };
  #services.gnome-keyring.enable = true;

}
