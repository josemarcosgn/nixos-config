{ ... }:

{
  # Graphical Interface (Plasma 6, Wayland by default — the X server is not
  # explicitly enabled.)
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # KDE Connect
  programs.kdeconnect.enable = true;
}
