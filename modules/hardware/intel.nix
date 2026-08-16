{ pkgs, ... }:

{
  # Enable Intel microcode updates.
  hardware.cpu.intel.updateMicrocode = true;

  # Hardware video acceleration (VA-API) for modern Intel.
  # `enable32Bit` is needed by 32-bit apps (Steam, Wine) and by VM guests
  # that use the host driver.
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = [ pkgs.intel-media-driver ];
  };

  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";
}
