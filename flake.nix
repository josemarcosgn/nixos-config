{
  description = "NixOS System Flake Configuration";

  inputs = {
    # Current NixOS release. Tracking the release branch (not nixos-unstable)
    # means updates are backported fixes rather than a moving target; the
    # channel is bumped by hand, once per release, after reading the release
    # notes. `system.stateVersion` is deliberately NOT tied to this: it records
    # which release the machine's *state* was created under and stays put.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
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
