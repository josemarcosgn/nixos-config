{ ... }:

{
  imports = [
    # Result of the hardware scan (do not edit by hand).
    ./hardware-configuration.nix
    ./vm-variant.nix

    ../../modules/core
    # Desktop-agnostic bits only; the desktop module itself (plasma.nix or
    # gnome.nix) is appended by flake.nix.
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
