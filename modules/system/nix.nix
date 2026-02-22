{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  nix.package = pkgs.nix;
  nix.channel.enable = false;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.registry = {
    osbuild.flake = inputs.self;
  }
  // lib.mapAttrs (_: flakes: { flake = flakes; }) inputs;

  nix.settings.substituters = [
    "https://nix-community.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nix.optimise.automatic = true;
  nix.settings.auto-optimise-store = true;
}
