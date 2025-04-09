# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];
  # Enable nix-command and flakes.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  home-manager = {
  # also pass inputs to home-manager modules
    extraSpecialArgs = {inherit inputs;};
    users = {
      "jose" = import ./home.nix;
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Disables NVMe APST to avoid firmware/driver issues and fix boot delay (~17s faster boot) 
  boot.kernelParams = [ "nvme_core.default_ps_max_latency_us=0" ];
  
  # Blacklist the i915 driver since this system uses a Xeon CPU without integrated graphics.
  boot.blacklistedKernelModules = [ "i915" ];

  # Enable performance mode.
  powerManagement.cpuFreqGovernor = "performance";
  
  # Disable sleep, suspend, hibernate and hybrid-sleep.
  systemd = {
    targets = {
      sleep = {
        enable = false;
        unitConfig.DefaultDependencies = "no";
      };
      suspend = {
        enable = false;
        unitConfig.DefaultDependencies = "no";
      };
      hibernate = {
        enable = false;
        unitConfig.DefaultDependencies = "no";
      };
      "hybrid-sleep" = {
        enable = false;
        unitConfig.DefaultDependencies = "no";
      };
    };
  }; 
  
  # Disables the wait-online service to prevent boot delays caused by waiting for network connectivity.
  systemd.services."NetworkManager-wait-online".enable = false;

  networking.hostName = "nixos"; # Define your hostname.
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  
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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  
  # NTFS support
  boot.supportedFilesystems = [ "ntfs" ];
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jose = {
    isNormalUser = true;
    description = "Jose Marcos";
    extraGroups = [ "networkmanager" "wheel" "adbusers" ];
    packages = with pkgs; [
    firefox
    flatpak
    gnome-software
    scrcpy
    hunspell
    gsound
    libgda6
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Enable Flatpak Support
  services.flatpak.enable = true;
  
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    vlc
    telegram-desktop
  ];
  
  # Exclde packages installed by default
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

  programs.hyprland = {
    enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

} # # Disables APST on NVMe to fix boot delay (~17s faster)
