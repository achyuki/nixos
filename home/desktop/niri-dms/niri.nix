{ config, pkgs, ... }:
{
  programs.niri = {
    enable = true;
    package = pkgs.niri;
    settings = {
      hotkey-overlay.skip-at-startup = true;
      gestures.hot-corners.enable = false;
      prefer-no-csd = true;
      screenshot-path = "~/Pictures/Screenshots/Screenshot_%Y-%m-%d_%H-%M-%S.png";

      input = {
        focus-follows-mouse.enable = true;
        keyboard.numlock = true;
        touchpad = {
          tap = true;
          natural-scroll = true;
        };
      };
      environment = {
        DISPLAY = ":0";
        # https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland
        #XMODIFIERS = "@im=fcitx";
        #GTK_IM_MODULE = "fcitx";
        #QT_IM_MODULE = "fcitx";
        QT_QPA_PLATFORMTHEME = "qt6ct";
        LC_MESSAGES = "zh_CN.UTF-8";
      };
      spawn-at-startup = [
        { command = [ "${pkgs.xwayland-satellite}/bin/xwayland-satellite" ]; }
      ];
      binds = with config.lib.niri.actions; {
        "Mod+E" = {
          hotkey-overlay.title = "Open File Manager";
          action.spawn = "dolphin";
        };
      };
    };
  };
}
