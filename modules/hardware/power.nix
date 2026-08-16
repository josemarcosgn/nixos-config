{ ... }:

{
  # Battery and power tuning
  services.tlp.enable = false; # Disabled in favour of KDE's native integration.
  services.power-profiles-daemon.enable = true; # Recommended for modern desktops like KDE Plasma.
  services.thermald.enable = true; # Intel thermal management
}
