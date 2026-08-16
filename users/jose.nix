{ pkgs, ... }:

{
  # Single source of truth for the user account and its groups.
  users.users.jose = {
    isNormalUser = true;
    description = "José Marcos";
    extraGroups = [
      "wheel" # sudo
      "networkmanager" # manage network connections
      "docker" # use the Docker daemon without sudo
      "libvirtd" # manage VMs through libvirt
      "kvm" # access to /dev/kvm
    ];
    packages = with pkgs; [
      kdePackages.kate
      vscodium
    ];
  };
}
