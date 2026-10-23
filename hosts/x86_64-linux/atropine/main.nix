{
  config,
  pkgs,
  lib,
  modules,
  ...
}:
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
      users.root
      users.yuki

      # Base
      boot
      kernel
      initrd
      network
      zram
      dms-greeter # greetd
      tailscale
      dae

      # Desktop
      audio
      bluetooth
      fonts
      polkit
      dbus
      udev

      # Packages
      fhs
      nix-ld
      direnv
      fuse
      nvim
      podman
      distrobox
      libvirt
      extpkgs
      wireshark
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
        obs-studio
        localconn
        chrome # firefox
        devenv
        develop
        obsidian
        splayer
        clash
        workstation
        libreoffice
        steam
        wine
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

  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "udev-rules-custom";
      text = ''
        SUBSYSTEM=="hidraw", GROUP="input", MODE="0660", TAG+="uaccess"
        SUBSYSTEM=="kvmfr", GROUP="kvm", MODE="0660", TAG+="uaccess"
      '';
      destination = "/etc/udev/rules.d/70-rules-custom.rules";

      checkPhase = ''
        ${config.systemd.package}/bin/udevadm verify --resolve-names=late $out/etc/udev/rules.d/70-rules-custom.rules
      '';
    })
  ];

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

  /*
    hardware.tuxedo-rs = {
      enable = true;
      tailor-gui.enable = true;
    };
  */

  boot.kernelParams = [
    "intel_iommu=on"
    "iommu=pt"
    "kvm.ignore_msrs=1"
  ];

  boot.initrd.kernelModules = [
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
  ];

  boot.extraModprobeConfig = ''
    options vfio-pci ids=10de:2d19,10de:22eb
    options kvmfr static_size_mb=64
  '';

  boot.blacklistedKernelModules = [
    "nvidia"
    "nvidia_drm"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_wmi_ec_backlight"
  ];

  boot.kernelModules = [ "kvmfr" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ kvmfr ];
  virtualisation.libvirtd.qemu.verbatimConfig = ''
    namespaces = []
    cgroup_device_acl = [
      "/dev/null", "/dev/full", "/dev/zero",
      "/dev/random", "/dev/urandom",
      "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
      "/dev/rtc", "/dev/hpet",
      "/dev/vfio/vfio", "/dev/kvmfr0"
    ]
  '';

}
// {
  home-manager.users.yuki.home.stateVersion = nixosVersion;
  system.stateVersion = nixosVersion;
  networking.hostName = hostName;
}
