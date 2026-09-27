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
        source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/persistent/${path}";
      };
    }) config.pref.persistent
  );
}
