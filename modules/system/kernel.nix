{
  lib,
  pkgs,
  ...
}:
{
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
    "vm.swappiness" = 10;
  };
}
