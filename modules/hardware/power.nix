{ ... }:

{
  # Battery and power tuning
  services.tlp.enable = false; # Disabled in favour of the desktop's own integration.
  services.power-profiles-daemon.enable = true; # What Plasma and GNOME both drive.
  services.thermald.enable = true; # Intel thermal management
}
