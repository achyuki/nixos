{
  config,
  inputs,
  pkgs,
  lib,
  util,
  platform,
  ...
}:
let
  cfg = config.nixpkgs;
  isCross = cfg.buildPlatform != cfg.hostPlatform;
  systemArgs =
    if isCross then {
      localSystem = cfg.buildPlatform;
      crossSystem = cfg.hostPlatform;
    } else {
      localSystem = cfg.hostPlatform;
    };
in
{
  nixpkgs.hostPlatform = lib.mkDefault platform;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = lib.mkAfter ([
    (final: prev: { localPkgs = util.loadPackages pkgs "${inputs.self.outPath}/packages"; })
    inputs.llm-agents.overlays.shared-nixpkgs
  ] ++ util.loadOverlays "${inputs.self.outPath}/overlays");

  _module.args.pkgs = lib.mkForce (
    util.genHybridPkgs {
      inherit (inputs) nixpkgs nixpkgs-stable nur;
      pkgArgs = { inherit (config.nixpkgs) config overlays; } // systemArgs;
    }
  );
}
