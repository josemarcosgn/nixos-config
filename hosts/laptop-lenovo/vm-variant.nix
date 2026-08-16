{ lib, ... }:

{
  # Settings that apply only to `nixos-rebuild build-vm`, never to the real
  # system.
  #
  # The VM boots a synthetic disk image, so the LUKS device declared in
  # hardware-configuration.nix does not exist inside the guest. Without
  # clearing it the VM stops in the initrd waiting for a passphrase that would
  # unlock nothing. The filesystems themselves need no such treatment: the
  # qemu-vm module already replaces them with mkVMOverride.
  virtualisation.vmVariant = {
    boot.initrd.luks.devices = lib.mkForce { };

    virtualisation = {
      memorySize = 4096; # the 1024 MB default is not enough for a full desktop
      cores = 4;
    };
  };
}
