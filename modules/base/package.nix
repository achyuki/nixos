{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    wget curl git gnupg rsync socat
    which file screen unzip zstd
    lsof psmisc

  ];
}
