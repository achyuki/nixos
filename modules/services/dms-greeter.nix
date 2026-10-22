{ pkgs, inputs, ... }:
{
  imports = [ inputs.dank-greeter.nixosModules.default ];

  programs.dms-greeter = {
    enable = true;
    compositor.name = "niri";
    configHome = "/home/yuki";
  };

  # Compositors must be installed via NixOS configuration to appear in DankGreeter, not via home-manager.
  environment.systemPackages = [ pkgs.niri ];
  services.displayManager.sessionPackages = [ pkgs.niri ];
}
