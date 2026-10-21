{ pkgs, ... }:
{
  home.packages = with pkgs; [
  ];
  pref.persistent = [
    ".config/nvim"
  ];

}
