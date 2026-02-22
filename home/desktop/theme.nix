{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # QT fix
    kdePackages.qt6ct
    libsForQt5.qt5ct

    # Themes
    adwaita-icon-theme
    darkly
    darkly-qt5

    # Cursors
    bibata-cursors
  ];

  # GTK fix
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
  };
}
