{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    which
    wget
    unzip
    eza
    dig
    whois
    bat
    ripgrep
    fastfetch
    hyfetch
    lsof
    psmisc
    pciutils
    usbutils
  ];
}
