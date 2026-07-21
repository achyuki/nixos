{
  lib,
  util,
  inputs,
  modules,
  ...
}:
let
  configPath = ../configs;
in
lib.concatMapAttrs (
  platform: _:
  util.collectModules (
    path:
    lib.nixosSystem {
      system = platform;
      modules = with modules.nixosModules; (_global ++ [ internal path ]);
      specialArgs = { inherit inputs util modules; };
    }
  ) "${configPath}/${platform}"
) (builtins.readDir configPath)
