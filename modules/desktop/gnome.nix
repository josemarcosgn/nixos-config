{ pkgs, ... }:

{
  # Graphical Interface (GNOME on Wayland — GDM defaults to Wayland and the X
  # server is not explicitly enabled.)
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # KDE Connect, as the GNOME Shell extension. The NixOS module opens the same
  # TCP/UDP range 1714-1764 either way; only the package differs.
  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  # GNOME installs a broad default app set. These either duplicate software the
  # system already provides or go unused here. Extend the list freely — it only
  # filters what the desktop module would install.
  environment.gnome.excludePackages = with pkgs; [
    epiphany # web browser; programs/firefox.nix already provides one
    gnome-tour # first-run onboarding, shown once
    gnome-music
    gnome-maps
    gnome-weather
  ];
}
