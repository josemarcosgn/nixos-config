{
  description = "NixOS System Flake Configuration";

  inputs = {
    # Using nixos-unstable since system.stateVersion is 25.11
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      laptop-lenovo = nixpkgs.lib.nixosSystem {
        # `system` is intentionally omitted: the architecture comes from
        # `nixpkgs.hostPlatform`, set in hardware-configuration.nix.
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/laptop-lenovo
        ];
      };
    };
  };
}
