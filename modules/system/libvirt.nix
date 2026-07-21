{
  pkgs,
  ...
}:
{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.libvirtd.qemu.vhostUserPackages = [ pkgs.virtiofsd ];
  programs.virt-manager.enable = true;
}
