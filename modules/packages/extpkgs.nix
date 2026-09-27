{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pciutils usbutils
    fastfetch hyfetch btop
    ripgrep fd eza fzf zellij jq
    dig whois nmap

  ];
}
