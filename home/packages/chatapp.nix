{ pkgs, ... }: {
  home.packages = with pkgs; [
    telegram-desktop
  ];
  services.flatpak.packages = [
    "com.tencent.WeChat"
    #"com.qq.QQ"
  ];
  services.flatpak.overrides.settings."com.tencent.WeChat" = {
    Environment.QT_IM_MODULE = "fcitx";
  };
}
