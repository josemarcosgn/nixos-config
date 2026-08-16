{ pkgs, ... }:

{
  # Bootloader
  boot.loader.systemd-boot = {
    enable = true;
    # Cap the number of generations in the boot menu. Without this the EFI
    # partition (typically ~512 MB) fills up with old kernels and rebuilds fail.
    configurationLimit = 10;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Adds support for the NTFS file system.
  boot.supportedFilesystems.ntfs = true;
}
