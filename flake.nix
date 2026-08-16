{
  description = "NixOS System Flake Configuration";

  inputs = {
    # Using nixos-unstable since system.stateVersion is 25.11
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      # The laptop, parameterised by its desktop environment. Hardware, users
      # and programs are shared by construction, so the variants cannot drift
      # apart: only the desktop module differs.
      laptop = desktop: nixpkgs.lib.nixosSystem {
        # `system` is intentionally omitted: the architecture comes from
        # `nixpkgs.hostPlatform`, set in hardware-configuration.nix.
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/laptop-lenovo
          desktop
        ];
      };
    in
    {
      nixosConfigurations = {
        # One machine, one hostname, two desktops. Both are buildable at any
        # time; whichever was last activated is the one that boots.
        laptop-lenovo = laptop ./modules/desktop/plasma.nix;
        laptop-gnome = laptop ./modules/desktop/gnome.nix;
      };
    };
}
