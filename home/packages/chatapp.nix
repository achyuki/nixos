{ pkgs, ... }: {
  home.packages = with pkgs;[
    telegram-desktop
 ];
  services.flatpak.packages = [
      "com.tencent.WeChat"
      #"com.qq.QQ"
  ];
}
