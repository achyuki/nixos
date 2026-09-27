{
  config,
  lib,
  inputs,
  ...
}:
{
  options.pref = {
    nix-cnmirror = lib.mkEnableOption "Enable CN mirrors for nix channels.";
    nix-autogc = lib.mkEnableOption "Enable auto gc for nix store.";
  };

  config = {
    nix.channel.enable = false;
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    nix.registry = {
      osbuild.flake = inputs.self;
    }
    // lib.mapAttrs (_: flakes: { flake = flakes; }) inputs;

    nix.settings.substituters =
      lib.optionals config.pref.nix-cnmirror [
        "https://mirror.sjtu.edu.cn/nix-channels/store"
      ]
      ++ [ "https://nix-community.cachix.org" ];
    nix.settings.trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    nix.optimise.automatic = true;
    nix.settings.auto-optimise-store = true;

    nix.gc = lib.mkIf config.pref.nix-autogc {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
