{ config, lib, pkgs, modules, ... }:
let
  nixosVersion = "26.05";
  hostName = "ice";
in
{
  imports =
    with modules.nixosModules;
    with system;
    with services;
    with packages;
    [
      users.root users.yuki

      droidspaces nix locale security sops
      openssh gpg-agent

      git nix-ld nvim htop
      extpkgs
  ];

  pref.home-manager.yuki = {
    enable = true;
    modules =
      with modules.homeModules;
      with packages;
      [
        git shell starship atuin
        
        persistent
        ./home.nix
      ];
  };

  pref.nix-cnmirror = true;
}
// {
  nixpkgs.hostPlatform = "aarch64-linux";
  home-manager.users.yuki.home.stateVersion = nixosVersion;
  system.stateVersion = nixosVersion;
  networking.hostName = hostName;
}
