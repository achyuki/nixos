{ config, pkgs, lib, ... }:
let
  kernel = pkgs.buildLinux {
    src = pkgs.fetchFromGitHub {
      owner = "torvalds";
      repo = "linux";
      rev = "d135ab453a7400a34930bdda1ef4bdc8acfac80e";
      hash = "sha256-rK+BaJJbaAXLqzH4GgQPkFN1gq3O6wtxKMxMXzw1Rig=";
    };
    kernelPatches = with pkgs.kernelPatches; [
      bridge_stp_helper
      request_key_helper
      {
        name = "sn6245-ptl";
        patch = ../../../patches/sn6245-ptl.patch;
      }
      {
        name = "uniwill-platform-profile";
        patch = ../../../patches/uniwill-platform-profile.patch;
      }
      {
        name = "uniwill-laptop";
        patch = null;
        structuredExtraConfig = with pkgs.lib.kernel; {
          X86_PLATFORM_DEVICES = yes;
          X86_PLATFORM_DRIVERS_UNIWILL = yes;
          UNIWILL_LAPTOP = module;
        };
      }
    ];
    # TODO: ccache miss
    /*stdenv = pkgs.ccacheStdenv.override {
      extraConfig = ''
        export CCACHE_DIR=${config.programs.ccache.cacheDir}
        export CCACHE_COMPRESS=1
        export CCACHE_SLOPPINESS=random_seed
      '';
    };*/
    version = "7.3";
    modDirVersion = "7.3.0";
    ignoreConfigErrors = true;
  };

  alsa-ucm-conf-patched = pkgs.alsa-ucm-conf.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or [ ]) ++ [
      ../../../patches/sn624x-ucm-1.2.16.1.patch
    ];
  });
in
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
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };
  # TODO
  /*services.xserver.videoDrivers = [ "nvidia" ];
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
  };*/

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
    options uniwill-laptop force=1
    options kvmfr static_size_mb=64
    options vfio-pci ids=10de:2d19,10de:22eb
  '';
  boot.initrd.kernelModules = [
    "vfio"
    "vfio_pci"
    "vfio_iommu_type1"
  ];
  boot.blacklistedKernelModules = [
    "nvidia"
    "nvidia_drm"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_wmi_ec_backlight"
  ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ kvmfr ];
  boot.kernelModules = [ "uniwill-laptop" "kvmfr" ];
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

  # TODO
  boot.kernelPackages = lib.mkForce (pkgs.linuxPackagesFor kernel);

  environment.sessionVariables = {
    ALSA_CONFIG_UCM2 = "${alsa-ucm-conf-patched}/share/alsa/ucm2";
  };

}
