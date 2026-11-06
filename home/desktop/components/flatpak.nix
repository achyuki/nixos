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
    packages = [
      "com.github.tchx84.Flatseal"
    ];
    overrides.settings = {
      global.Context = {
        filesystems = [ "xdg-download" ];
      };
    };
  };
  
}
