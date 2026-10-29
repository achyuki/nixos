{ config, pkgs, ... }:
{
  programs.ccache.enable = true;
  nix.settings.extra-sandbox-paths = [ (toString config.programs.ccache.cacheDir) ];
  environment.systemPackages = [ pkgs.ccache ];
}
