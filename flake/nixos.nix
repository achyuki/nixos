{
  lib,
  util,
  inputs,
  modules,
  ...
}:
let
  configPath = ../hosts;
in
lib.concatMapAttrs (
  platform: _:
  util.collectModules (
    path:
    lib.nixosSystem {
      modules = with modules.nixosModules; (_global ++ [ base path ]);
      specialArgs = { inherit inputs util modules platform; };
    }
  ) (configPath + "/${platform}")
) (builtins.readDir configPath)
