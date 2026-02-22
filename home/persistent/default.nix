{
  config,
  lib,
  ...
}:
let
  activePaths = [
    "Pictures/wallpaper"
    "Pictures/avatar.webp"
    ".config/nvim"
    ".config/DankMaterialShell"
    ".config/qt5ct/qt5ct.conf"
    ".config/qt6ct/qt6ct.conf"
    ".config/kitty"
    ".config/dolphinrc"
  ];
in
{
  home.file = lib.listToAttrs (
    map (path: {
      name = path;
      value = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/home/persistent/${path}";
      };
    }) activePaths
  );
}
