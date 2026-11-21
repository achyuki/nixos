{ config, lib, ... }: {
  options.pref.sudo-strict = lib.mkEnableOption "Enable sudo password.";

  config = {
    security.sudo.wheelNeedsPassword = config.pref.sudo-strict;
    security.sudo-rs.wheelNeedsPassword = config.pref.sudo-strict;

    networking.firewall.enable = lib.mkDefault false;
  };
}
