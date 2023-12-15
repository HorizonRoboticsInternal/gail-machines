{
  description = "Collection of GAIL NixOS machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    nixpkgs-nvidia520.url = "github:NixOS/nixpkgs?rev=c1254eebab9a7257e978af1009d9ba2133befcec";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixos-hardware, vital-modules, nixos-home, ... }@inputs: {
    nixosModules = {
      downgrade-to-nvidia520 = {config, lib, pkgs, ...}:
        let pkgs' = import inputs.nixpkgs-nvidia520 {
              system = "x86_64-linux";
              config.allowUnfree = true;
            }; in {
              boot.kernelPackages = pkgs'.linuxPackages;
              hardware.nvidia.package = pkgs'.linuxPackages.nvidiaPackages.latest;
            };
    };

    nixosConfigurations = {
      stormveil = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machines/stormveil
        ];
      };
    };
  };
}
