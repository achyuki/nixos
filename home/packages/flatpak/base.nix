{ pkgs, inputs, ... }:
{
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  home.packages = [ pkgs.flatpak ];
  services.flatpak = {
    enable = true;
    remotes = [
      {
        name = "flathub";
        location = "https://mirror.sjtu.edu.cn/flathub";
      }
    ];
    update.auto = {
      enable = false;
      onCalendar = "weekly";
    };
      overrides = {
        global.Context = {
          filesystems = [ "xdg-download" ];
        };
      };
  };

  xdg.portal = {
    enable = true;
    config.common = {
      default = [ "gtk" "wlr" ];
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };
}
