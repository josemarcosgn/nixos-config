{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix  # Include the results of the hardware scan.
      inputs.home-manager.nixosModules.default # Home Manager
      ./nvidia-config.nix
    ];
  # Enable nix-command and flakes.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  
  
  home-manager = {
  # also pass inputs to home-manager modules
    extraSpecialArgs = {inherit inputs;};
    users = {
      "jose" = import ../home.nix;
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Disables the wait-online service to prevent boot delays caused by waiting for network connectivity.
  systemd.services."NetworkManager-wait-online".enable = false;

  networking.hostName = "nixos-x550ln"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  
  # Exclde GNOME packages installed by default
  environment.gnome.excludePackages = with pkgs; [
    baobab # disk usage analyzer
    epiphany # web browser
    simple-scan # document scanner
    totem # video player
    yelp # help viewer
    evince # document viewer
    geary # email client
    gnome-contacts
    gnome-logs
    gnome-maps
    gnome-music
    gnome-shell-extensions
  ]; 
  
  # Hidden xterm ON app menu.
  services.xserver.excludePackages = [ pkgs.xterm ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };
  
  # Configure console keymap
  console.keyMap = "br-abnt2";
  
  # Virtualisation services 
  
  # Virt-manager Enable
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["jose"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  
  # Docker enable
  virtualisation.docker = {
    enable = true;
    daemon.settings.debug = false;
  };
  
  # Waydroid
  virtualisation.waydroid.enable = true;
  
  # Enable ADB tool
  programs.adb.enable = true;
  
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  
  # NTFS support
  boot.supportedFilesystems = [ "ntfs" ];
  
  
  # Define a user account.
  users.users.jose = {
    isNormalUser = true;
    description = "Jose Marcos";
    extraGroups = [ "networkmanager" "wheel" "adbusers" "docker" ];
    packages = with pkgs; [
    firefox
    flatpak
    gnome-software
    scrcpy
    hunspell
    gsound
    libgda6
    vlc
    wget
    telegram-desktop
    ntfs3g
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Enable Flatpak Support
  services.flatpak.enable = true;
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ];

  system.stateVersion = "24.11"; # Did you read the comment?

}
