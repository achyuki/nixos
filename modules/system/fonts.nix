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
    lxgw-wenkai
    maple-mono.Normal-NF
  ];

  fonts.fontconfig = {
    enable = true;
    antialias = true;
    useEmbeddedBitmaps = true;
    hinting.enable = true;
    defaultFonts = {
      serif = [
        "LXGW WenKai"
        "Noto Serif CJK SC"
      ];
      sansSerif = [
        "LXGW WenKai"
        "Noto Sans CJK SC"
      ];
      monospace = [ "Maple Mono Normal NF" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  fonts.fontDir.enable = true;
}
