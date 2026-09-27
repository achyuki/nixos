{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.x86_64-linux.default
    wget curl git gnupg rsync socat
    which file unzip zstd
    lsof psmisc

  ];
}
