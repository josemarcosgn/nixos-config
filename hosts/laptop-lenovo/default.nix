{ ... }:

{
  imports = [
    # Result of the hardware scan (do not edit by hand).
    ./hardware-configuration.nix

    ../../modules/core
    ../../modules/desktop
    ../../modules/hardware
    ../../modules/programs
    ../../modules/virtualisation

    ../../users/jose.nix
  ];

  networking.hostName = "laptop-lenovo";

  # NixOS release this machine's state is compatible with.
  # Do NOT change without reading the release notes.
  system.stateVersion = "25.11";
}
