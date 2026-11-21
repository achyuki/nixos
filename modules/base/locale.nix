{ lib, ... }: {
  time.timeZone = lib.mkDefault "Asia/Shanghai";
  i18n = lib.mkDefault {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_MEASUREMENT = "zh_CN.UTF-8";
      LC_MONETARY = "zh_CN.UTF-8";
      LC_PAPER = "zh_CN.UTF-8";
    };
  };
}
