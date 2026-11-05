{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    wget curl git gnupg rsync socat
    which file unzip zstd
    lsof psmisc

  ];
}
