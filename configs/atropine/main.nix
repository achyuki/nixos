{ config, pkgs, modules, ... }:
let
  nixosVersion = "25.11";
  hostName = "atropine";
in
{
  imports =
    with modules.nixosModules;
    with system;
    with services;
    with packages;
    [
      #disko.ext4-swap
      users.root users.yuki

      # Base
      boot kernel initrd locale net nix zram sops docs git
      openssh gpg-agent tailscale dae

      # Desktop
      audio bluetooth fonts greetd security polkit
      dconf upower gvfs accounts
      #polkit-agent

      # Packages
      nix-ld nvim htop tmux direnv # base
      android-tools extpkgs # tools
      podman distrobox libvirt #wine # virt
    ];
  pref.home-manager.yuki = {
    enable = true;
    modules =
      with modules.homeModules;
      with desktop;
      with packages;
      [
        # Desktop
        niri-dms shell starship stylix kitty fcitx5 dolphin theme

        # Packages
        git # non-gui
        firefox obs-studio vlc mission-center flclash # system
        kdeconnect localsend # tools
        vscode # develop
        telegram flatpak.chat # social

        # Persistent data
        persistent

        ./home.nix
      ];
  };
  pref.nix-cnmirror = true;
  #disko.devices.disk.main.device = "/dev/sda";
  
}
// {
  home-manager.users.yuki.home.stateVersion = nixosVersion;
  system.stateVersion = nixosVersion;
  networking.hostName = hostName;
}
