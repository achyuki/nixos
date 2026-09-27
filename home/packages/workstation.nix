{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gimp
    #davinci-resolve
    #kdePackages.kdenlive
    #inkscape
    #krita
    #blender
  ];
}
