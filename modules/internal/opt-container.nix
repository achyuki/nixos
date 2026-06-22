{ config, lib, ... }:
{
  options.pref.isContainer = lib.mkEnableOption "Whether the environment is a lightweight container.";
  config = lib.mkIf config.pref.isContainer
    ({
      boot.isContainer = true;
      networking.dhcpcd.enable = false;
      networking.firewall.enable = false;
      systemd.services.firewall = lib.mkForce {
        enable = false;
      };
      documentation.enable = false;
      documentation.man.enable = false;
    });
}
