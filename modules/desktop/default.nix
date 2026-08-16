{ ... }:

{
  # Desktop-agnostic pieces only. The desktop environment itself is NOT
  # imported here: flake.nix appends plasma.nix or gnome.nix per configuration,
  # which is what makes the two variants possible.
  imports = [
    ./audio.nix
    ./flatpak.nix
    ./keyboard.nix
    ./printing.nix
  ];
}
