{ ... }:

{
  # Nix Settings (Flakes)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Automatic store cleanup. Without this, old generations pile up
  # indefinitely and fill the disk.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Deduplicate identical files in /nix/store.
  nix.optimise.automatic = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
