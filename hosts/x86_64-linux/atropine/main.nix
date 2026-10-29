{ modules, ... }:
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
      boot kernel network zram binfmt
      dms-greeter #greetd
      tailscale #dae

      # Desktop
      audio bluetooth fonts polkit dbus udev

      # Packages
      fhs nix-ld direnv fuse nvim ccache
      podman distrobox libvirt
      extpkgs wireshark

      ./drivers.nix
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
        obs-studio localconn remmina chrome #firefox
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


}
// {
  home-manager.users.yuki.home.stateVersion = nixosVersion;
  system.stateVersion = nixosVersion;
  networking.hostName = hostName;
}
