lib: rec {
  collectModules =
    call: directory:
    lib.concatMapAttrs (
      name: type:
      let
        path = directory + "/${name}";
        defaultPath = path + "/default.nix";
      in
      if type == "directory" && lib.pathExists defaultPath then
        { "${name}" = call defaultPath; }
      else if type == "directory" then
        { "${name}" = collectModules call path; }
      else if type == "regular" && lib.hasSuffix ".nix" name then
        { "${lib.removeSuffix ".nix" name}" = call path; }
      else
        { }
    ) (builtins.readDir directory);

  loadModules = directory: collectModules (path: import path) directory;

  loadPackages = pkgs: directory: collectModules (path: pkgs.callPackage path {}) directory;

  loadOverlays = directory: lib.attrValues (loadModules directory);

  genHybridPkgs =
    {
      nixpkgs,
      nixpkgs-stable,
      nur,
      pkgArgs ? { },
    }:
    let
      topArgs = pkgArgs // {
        overlays = pkgArgs.overlays ++ [ nur.overlays.default ];
      };
      pkgs = import nixpkgs topArgs;
    in
    pkgs // { _stable = import nixpkgs-stable pkgArgs; };
}
