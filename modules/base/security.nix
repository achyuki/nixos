{ lib, ... }: {
  security.sudo.wheelNeedsPassword = lib.mkDefault false;
  security.sudo-rs.wheelNeedsPassword = lib.mkDefault false;
  networking.firewall.enable = lib.mkDefault false;
}
