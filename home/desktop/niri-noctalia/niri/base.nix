{ config, ... }:
{
  programs.niri.settings = {
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
      XDG_CURRENT_DESKTOP = "niri";
      XMODIFIERS = "@im=fcitx";
      # GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      QT_QPA_PLATFORMTHEME = "qt5ct";
    };

  };
}
