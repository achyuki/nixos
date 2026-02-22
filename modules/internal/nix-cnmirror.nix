{ config, lib, ... }:
{
  options.pref.nix-cnmirror = lib.mkEnableOption "Enable nix-channels CN mirrors.";
  config.nix.settings.substituters = lib.mkIf config.pref.nix-cnmirror
    (lib.mkBefore [ "https://mirror.sjtu.edu.cn/nix-channels/store" ]);
}
