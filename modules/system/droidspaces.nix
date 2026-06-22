{ config, pkgs, lib, modulesPath, ... }:
let
  droidspacesConfigIf = pattern:
    pkgs.writeShellScript "config-if" ''
      grep -q ${lib.escapeShellArg pattern} /run/droidspaces/container.config
    '';
in
{
  boot.isContainer = true;
  # Android kernel imposes network restrictions on uid >= 10000
  ids.uids.nixbld = lib.mkForce 9300;
  nix.optimise.automatic = lib.mkForce false;

  systemd.services.register-nix-paths = {
    description = "Register Nix Store Paths";
    unitConfig = {
      DefaultDependencies = false;
      ConditionPathExists = "/nix-path-registration";
    };
    wantedBy = [ "sysinit.target" ];
    before = [
      "sysinit.target"
      "shutdown.target"
      "nix-daemon.socket"
      "nix-daemon.service"
    ];
    after = [ "local-fs.target" ];
    conflicts = [ "shutdown.target" ];
    restartIfChanged = false;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      ${lib.getExe' config.nix.package.out "nix-store"} --load-db < /nix-path-registration
      rm /nix-path-registration

      # nixos-rebuild also requires a "system" profile
      ${lib.getExe' config.nix.package.out "nix-env"} -p /nix/var/nix/profiles/system --set /run/current-system
    '';
  };

  # supplement 99-ethernet-default-dhcp which excludes veth
  systemd.network = lib.mkIf config.networking.useDHCP {
    networks."99-lxc-veth-default-dhcp" = {
      matchConfig = {
        Type = "ether";
        Kind = "veth";
        Name = [
          "en*"
          "eth*"
        ];
      };
      DHCP = "yes";
      networkConfig.IPv6PrivacyExtensions = "kernel";
    };
  };

  system.build.installBootLoader = pkgs.writeScript "install-lxc-sbin-init.sh" ''
    #!${pkgs.runtimeShell}
    ${pkgs.coreutils}/bin/ln -fs "$1/init" /sbin/init
  '';

  # networkd depends on this, but systemd module disables this for containers
  systemd.additionalUpstreamSystemUnits = [ "systemd-udev-trigger.service" ];


  # These services are broken or unnecessaray in a droidspaces container
  systemd.services.nix-channel-init.enable = false;
  systemd.services.wpa_supplicant.enable = false;
  systemd.services.systemd-networkd-wait-online.enable = false;
  systemd.sockets.systemd-journald-audit.enable = false;

  networking.firewall.enable = false;
  systemd.services.firewall = lib.mkForce {
    enable = false;
  };

  # Only let these start on nat mode
  systemd.services.NetworkManager.serviceConfig.ExecCondition = [
    (droidspacesConfigIf "net_mode=nat")
  ];

  systemd.services.dhcpcd.serviceConfig.ExecCondition = [
    (droidspacesConfigIf "net_mode=nat")
  ];

  systemd.services.systemd-resolved.serviceConfig.ExecCondition = [
    (droidspacesConfigIf "net_mode=nat")
  ];

  #networking.nameservers = ["8.8.8.8" "1.1.1.1"];

  # Restrict udev to Android-safe subsystems only (prevent coldplugging host hardware)
  systemd.services.systemd-udev-trigger.serviceConfig.ExecStart = lib.mkForce [
    ""
    "-udevadm trigger --subsystem-match=usb --subsystem-match=block --subsystem-match=input --subsystem-match=tty --subsystem-match=net"
  ];
  # Clear ConditionPathIsReadWrite= from upstream units
  systemd.services.systemd-udevd.unitConfig.ConditionPathIsReadWrite = lib.mkForce [ ];
  systemd.services.systemd-udev-trigger.unitConfig.ConditionPathIsReadWrite = lib.mkForce [ ];
  systemd.services.systemd-udev-settle.unitConfig.ConditionPathIsReadWrite = lib.mkForce [ ];
  systemd.sockets.systemd-udevd-kernel.unitConfig.ConditionPathIsReadWrite = lib.mkForce [ ];
  systemd.sockets.systemd-udevd-control.unitConfig.ConditionPathIsReadWrite = lib.mkForce [ ];

  # Prevents systemd from acting on the power button when running
  # on Android, where the power key is used to wake/sleep the device.
  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
    HandleSuspendKey = "ignore";
    HandleHibernateKey = "ignore";
    HandlePowerKeyLongPress = "ignore";
    HandlePowerKeyLongPressHibernate = "ignore";
  };

  # Journald configuration (skip Audit, KMsg, etc)
  services.journald.extraConfig = ''
    ReadKMsg=no
    Audit=no
    Storage=volatile
    SystemMaxUse=50M
    RuntimeMaxUse=10M
    MaxRetentionSec=7day
    MaxLevelStore=info
  '';
}
