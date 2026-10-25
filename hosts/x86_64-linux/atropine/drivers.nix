{ config, pkgs, ... }:
{
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

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ ocl-icd config.boot.kernelPackages.nvidia_x11 ];
};
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

  /*boot.kernelPatches = [
    {
      name = "uniwill-laptop";
      patch = null;
      structuredExtraConfig = with pkgs.lib.kernel; {
        X86_PLATFORM_DEVICES = yes;
        X86_PLATFORM_DRIVERS_UNIWILL = yes;
        UNIWILL_LAPTOP = module;
      };
    }
  ];*/

  boot.kernelParams = [
    "intel_iommu=on"
    "iommu=pt"
    "kvm.ignore_msrs=1"
  ];
  #options uniwill-laptop force=1
  boot.extraModprobeConfig = ''
    options kvmfr static_size_mb=64
    options vfio-pci ids=10de:2d19,10de:22eb
  '';
  boot.initrd.kernelModules = [
    "vfio"
    "vfio_pci"
    "vfio_iommu_type1"
  ];
  /*boot.blacklistedKernelModules = [
    "nvidia"
    "nvidia_drm"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_wmi_ec_backlight"
  ];*/
  boot.kernelModules = [ "kvmfr" ]; #uniwill-laptop
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
