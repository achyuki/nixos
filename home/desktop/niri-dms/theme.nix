{
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.stylix.homeModules.stylix ];

  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
    polarity = "dark";

    # Let DMS manage these.
    /*
      targets.gtk.enable = true;
      targets.gtk.flatpakSupport.enable = true;
      targets.qt.enable = true;
      targets.kde.enable = true;

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };

      fonts = {
        serif.name = "LXGW WenKai Screen";
        serif.package = pkgs.lxgw-wenkai-screen;
        sansSerif.name = "LXGW WenKai Screen";
        sansSerif.package = pkgs.lxgw-wenkai-screen;
        monospace.name = "Maple Mono Normal NF";
        monospace.package = pkgs.maple-mono.Normal-NF;
        emoji.name = "Noto Color Emoji";
        emoji.package = pkgs.noto-fonts-color-emoji;
      };
    */
  };

  home.packages = with pkgs; [
    # Themes
    adw-gtk3
    #adwaita-icon-theme
    papirus-icon-theme
    darkly

    # Cursors
    bibata-cursors

    # patched version of qt6ct
    nur.repos.ilya-fedin.qt6ct
  ];

  /*gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
  };
  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };*/
}
