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

    # Let DMS manage these things.
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
        serif.name = "LXGW WenKai";
        serif.package = pkgs.lxgw-wenkai;
        sansSerif.name = "LXGW WenKai";
        sansSerif.package = pkgs.lxgw-wenkai;
        monospace.name = "Maple Mono Normal NF";
        monospace.package = pkgs.maple-mono.Normal-NF;
        emoji.name = "Noto Color Emoji";
        emoji.package = pkgs.noto-fonts-color-emoji;
      };
    */
  };
}
