{ pkgs, ... }:

{
  # Enable networking and openvpn.
  networking.networkmanager = {
    enable = true;
    plugins = [ pkgs.networkmanager-openvpn ];
  };
}
