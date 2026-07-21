{
  config,
  lib,
  pkgs,
  inputs,
  modules,
  ...
}:
let
  username = "yuki";
  cfg = config.pref.home-manager."${username}";
in
{
  options.pref.home-manager."${username}" = {
    enable = lib.mkEnableOption "Enable home-manager for ${username}.";
    modules = lib.mkOption {
      default = [ ];
      description = "Extra modules for home-manager";
    };
  };

  config = {
    users.users."${username}" = {
      isNormalUser = true;
      description = "AcetylYuki";
      shell = pkgs.fish;
      extraGroups = [
        "wheel"
        "networkmanager"
        "podman"
        "libvirtd"
        "adbusers"
      ];
      hashedPasswordFile = config.sops.secrets.password00.path;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOqNxUrlnSLf8Vr0RPOPydlwRltW0kMboxtxwLV/gBTV"
      ];
    };

    programs.fish.enable = true;

    home-manager = lib.mkIf cfg.enable {
      users."${username}" = {
        programs.home-manager.enable = true;
        imports = cfg.modules;
        home = {
          username = username;
          homeDirectory = "/home/${username}";
        };
      };
    };

    nix.settings.trusted-users = [ username ];
  };
}
