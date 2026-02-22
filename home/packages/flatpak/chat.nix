_: {
  imports = [ ./base.nix ];

  services.flatpak = {
    packages = [
      "com.tencent.WeChat"
      "com.qq.QQ"
    ];
  };
}
