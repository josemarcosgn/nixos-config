{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Basics
    git
    wget

    # Hardware / system diagnostics
    pciutils
    usbutils
    htop
    btop
    fastfetch

    # Disks and archives
    gparted
    rar
    p7zip

    # KDE
    kdePackages.keysmith
  ];
}
