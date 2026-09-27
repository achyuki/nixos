{
  pkgs,
  ...
}:
{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    lxgw-wenkai-screen
    maple-mono.Normal-NF
  ];

  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    fontconfig = {
    enable = true;
    antialias = true;
    useEmbeddedBitmaps = true;
    hinting.enable = true;
    defaultFonts = {
      serif = [
        "LXGW WenKai Screen"
        "Noto Serif CJK SC"
      ];
      sansSerif = [
        "LXGW WenKai Screen"
        "Noto Sans CJK SC"
      ];
      monospace = [ "Maple Mono Normal NF" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
  };

}
