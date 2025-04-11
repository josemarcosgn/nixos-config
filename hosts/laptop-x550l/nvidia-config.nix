# nvidia-config.nix
{ config, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:4:0:0";

      offload.enable = true;
      offload.enableOffloadCmd = true;
    };

    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
  };
  specialisation = {
    gaming-time.configuration = {

      hardware.nvidia = {
        prime.sync.enable = lib.mkForce true;
        prime.offload = {
          enable = lib.mkForce false;
          enableOffloadCmd = lib.mkForce false;
        };
      };

    };
  };
}

