{ config, pkgs, modules, ... }:
{
  home.packages = with pkgs; [
  ];
  pref.persistent = [
    ".config/nvim"
  ];

}
