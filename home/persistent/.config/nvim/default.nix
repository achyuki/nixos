{ config, ... }:
{
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-flake/home/desktop/nvim";
}
