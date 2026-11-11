final: prev: {
  appimage-run = prev.appimage-run.override {
    extraPkgs = pkgs: [ pkgs.icu ];
  };
}
