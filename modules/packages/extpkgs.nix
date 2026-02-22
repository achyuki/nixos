{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wget
    unzip
    tree
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
