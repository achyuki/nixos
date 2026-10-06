{ lib, modules, ... }:
let
  nixosVersion = "26.05";
  hostName = "unk";
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
      boot kernel initrd net zram
      tailscale dae

      # Desktop
      audio bluetooth fonts greetd polkit dbus mtp

      # Packages
      fhs nix-ld direnv nvim
      podman distrobox libvirt
      extpkgs
    ];
  pref.home-manager.yuki = {
    enable = true;
    modules =
      with modules.homeModules;
      with desktop;
      with packages;
      [
        # Desktop
        niri-dms

        # Packages
        obs-studio localconn chrome #firefox
        devenv develop obsidian splayer clash
        workstation
        steam wine
        chatapp

        ./home.nix
      ];
  };
  pref = {
    nix-cnmirror = true;
    nix-autogc = true;
    ssh-strict = true;
  };
  #disko.devices.disk.main.device = "/dev/sda";

  services.udev.extraRules = ''
    SUBSYSTEM=="hidraw", MODE="0666"
  '';

}
// {
  home-manager.users.yuki.home.stateVersion = nixosVersion;
  system.stateVersion = nixosVersion;
  networking.hostName = hostName;
}
