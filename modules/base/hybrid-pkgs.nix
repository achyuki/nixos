{
  config,
  pkgs,
  lib,
  inputs,
  util,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.localSystem = lib.mkDefault config.nixpkgs.hostPlatform;
  nixpkgs.overlays = [
    (final: prev: { localPkgs = util.loadPackages pkgs "${inputs.self.outPath}/packages"; })
    inputs.llm-agents.overlays.shared-nixpkgs
  ] ++ util.loadOverlays "${inputs.self.outPath}/overlays";

  _module.args.pkgs = lib.mkForce (
    util.genHybridPkgs ({
      inherit (inputs) nixpkgs nixpkgs-stable nur;
      pkgArgs = { inherit (config.nixpkgs) config overlays localSystem crossSystem hostPlatform; };
    })
  );
}
