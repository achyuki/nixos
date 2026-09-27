{ config, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      android-tools
      gcc clang-tools
      python3 uv
      fnm pnpm
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

  programs.fish.shellInit = ''
    fnm env --shell fish|source
  '';
}
