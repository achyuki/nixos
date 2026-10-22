{ config, lib, modules, ... }:
let
  nixosVersion = "26.05";
  hostName = "atropine";
in
{
  imports =
    with modules.nixosModules;
    with system;
    with services;
    with packages;
    [
      disko.luks-btrfs-swap
      users.root users.yuki

      # Base
      boot kernel initrd network zram dms-greeter#greetd
      tailscale dae

      # Desktop
      audio bluetooth fonts polkit dbus udev

      # Packages
      fhs nix-ld direnv fuse nvim
      podman distrobox libvirt
      extpkgs wireshark
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
        workstation libreoffice
        steam wine
        chatapp

        ./home.nix
      ];
  };
  disko.devices.disk.main.device = "/dev/nvme0n1";

  pref = {
    nix-cnmirror = true;
    nix-autogc = true;
    ssh-strict = true;
  };


  # TODO
  services.udev.extraRules = ''
    SUBSYSTEM=="hidraw", MODE="0666"
  '';

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = true;
    branch = "production";

    nvidiaSettings = true;
    modesetting.enable = true;
    powerManagement.enable = true;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:2@0:0:0";
    };
  };


}
// {
  home-manager.users.yuki.home.stateVersion = nixosVersion;
  system.stateVersion = nixosVersion;
  networking.hostName = hostName;
}
