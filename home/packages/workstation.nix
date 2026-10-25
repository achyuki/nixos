{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gimp
    #kdePackages.kdenlive
    #davinci-resolve
    #inkscape
    #krita
    #blender
  ];
}
