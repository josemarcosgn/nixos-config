{ config, pkgs, ... }:

{
  # Graphics support on the Host
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Hypervisor Configuration (Libvirt + QEMU)
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  # Virt-manager interface & USB Redirection
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true; # <-- Adicionado aqui!

  # Add user to the required groups
  users.users.jose.extraGroups = [ "libvirtd" "kvm" ];
}
