final: prev: {
  # https://github.com/NixOS/nixpkgs/blob/1d27f00d42c84a94061142577aa61fdc74ce823c/nixos/modules/i18n/input-method/fcitx5.nix#L96-L98
  fcitx5-rime-ice = prev.fcitx5-rime.override {
    rimeDataPkgs = [ final.rime-ice ];
  };

  # https://github.com/NixOS/nixpkgs/blob/acca705f5607a8524cc8db516550d5167c68b9f4/pkgs/by-name/ri/rime-ice/package.nix#L19-L30
  rime-ice = prev.rime-ice.overrideAttrs (oldAttrs: {
    postInstall = ''
      mv $out/share/rime-data/{rime_ice_suggestion,default}.yaml
    '';
  });
}
