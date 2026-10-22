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

  config.nix = {
    channel.enable = false;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters =
        lib.optionals config.pref.nix-cnmirror [
          "https://mirror.sjtu.edu.cn/nix-channels/store"
        ]
        ++ [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    registry = {
      osbuild.flake = inputs.self;
    }
    // lib.mapAttrs (_: flakes: { flake = flakes; }) inputs;

    optimise.automatic = true;
    settings.auto-optimise-store = true;

    gc = lib.mkIf config.pref.nix-autogc {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
