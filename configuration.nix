{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader & Kernel
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Módulos para Câmera Virtual do OBS
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];

  # Networking / Rede
  networking.hostName = "nixos"; # Define your hostname.
  # Enable networking
  networking.networkmanager.enable = true;

  # Time Zone & Clock
  time.timeZone = "America/Sao_Paulo";
  time.hardwareClockInLocalTime = true;

  # Internationalisation
  i18n.defaultLocale = "pt_BR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ALL = "pt_BR.UTF-8";
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

  # Graphics and Hardware Acceleration (Intel Raptor Lake)
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
    ];
  };

  # Otimização de Bateria e Energia
  services.tlp.enable = true;
  services.tlp.settings = {
    USB_EXCLUDE_BTUSB = 1;
    USB_DENYLIST = "04f3:0c4b";
  };
  services.power-profiles-daemon.enable = false;

  # Graphical Interface (Plasma 6)
  #services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Keyboard Layout
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };
  
  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Sound with Pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # User Account
  users.users.jose = {
    isNormalUser = true;
    description = "José Marcos";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
    packages = with pkgs; [
      kdePackages.kate
      vscodium
    ];
  };

  # Fingerprint Support
  services.fprintd.enable = true;
  security.pam.services.login.fprintAuth = true;
  security.pam.services.sudo.fprintAuth = true;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Nix Settings (Flakes)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System Packages
  environment.systemPackages = with pkgs; [
    git
    kdePackages.keysmith
    wget
    pciutils
    usbutils
    htop
    btop
    fastfetch
    virt-manager

    # OBS Studio com plugins específicos
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-vaapi
        obs-vkcapture
        obs-gstreamer
      ];
    })
  ];

  # Flatpak
  services.flatpak.enable = true;

  # Virtualization
  virtualisation.docker.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true;
    };
  };
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # NixOS Version
  system.stateVersion = "25.11";

}