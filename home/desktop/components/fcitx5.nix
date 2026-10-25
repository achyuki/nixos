{ pkgs, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        kdePackages.fcitx5-qt
        fcitx5-gtk
        fcitx5-rime-ice
        fcitx5-mellow-themes
      ];
      /*settings = {
        inputMethod = {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "rime";
          };
          "Groups/0/Items/0".Name = "rime";
        };
      };*/
      waylandFrontend = true;
    };
  };
  #stylix.targets.fcitx5.enable = true;
}
