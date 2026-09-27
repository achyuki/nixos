_: {
  programs.dconf.enable = true;
  services = {
    udisks2.enable = true;
    accounts-daemon.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
  };
}
