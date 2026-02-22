{
  lib,
  util,
  inputs,
  modules,
  ...
}:
util.collectModules (
  path:
  lib.nixosSystem {
    modules = with modules.nixosModules; (_global ++ [ internal path ]);
    specialArgs = { inherit inputs util modules; };
  }
) ../configs
