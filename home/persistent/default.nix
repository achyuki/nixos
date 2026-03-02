{ config, lib, ... }:
{
  options.pref.persistent = lib.mkOption {
    default = [ ];
    description = "Shared persistent data activation path.";
  };
  config.home.file = lib.listToAttrs (
    map (path: {
      name = path;
      value = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/home/persistent/${path}";
      };
    }) config.pref.persistent
  );
}
