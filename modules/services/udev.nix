{ pkgs, ... }:
{
  services.udev = {
    enable = true;
    packages = [
      pkgs.libmtp.out
    ];
  };
}
