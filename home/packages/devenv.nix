{ config, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      android-tools
      gcc clang-tools
      rustc cargo
      (python3.withPackages (ps: with ps; [ pip ])) uv
      nodejs_26 pnpm
      nixd nixfmt

    ];
    sessionPath = [
      "$HOME/.npm/bin"
    ];
    file = {
      ".npmrc".text = ''
        registry=https://registry.npmmirror.com
        prefix=${config.home.homeDirectory}/.npm
      '';
    };
  };
}
