_: {
  boot.loader={
    systemd-boot={
      enable = true;
      configurationLimit = 10;
    };
    efi.canTouchEfiVariables = true;
    timeout = 0; # Hold down space to enter the boot menu
  };
  boot.tmp.cleanOnBoot = true;
  boot.supportedFilesystems = [ "btrfs" "exfat" "ntfs" ];
}
