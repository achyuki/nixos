{ config, pkgs, inputs, ... }:
{
  imports = [ inputs.dms.nixosModules.greeter ];

  programs.dank-material-shell.greeter = {
    enable = true;
    compositor.name = "niri";
    configHome = "/home/yuki";
  };

  # Compositors must be installed via NixOS configuration to appear in DankGreeter, not via home-manager.
  environment.systemPackages = [ pkgs.niri ];
}
