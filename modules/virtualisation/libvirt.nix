{ pkgs, ... }:

{
  # Hypervisor Configuration (Libvirt + QEMU)
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true; # Emulated TPM, required by Windows 11 guests
    };
  };

  # Virt-manager interface & USB Redirection
  # (programs.virt-manager already installs the package — do not repeat it in
  # systemPackages.)
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # NOTE: the user's `libvirtd` and `kvm` groups live in users/jose.nix.
  # A reusable module must not hardcode the user name.
}
