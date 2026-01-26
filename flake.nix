{
  description = "Nixos config flake";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, agenix, nixos-hardware, ... }@inputs: {
    nixosConfigurations.pi = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/pi/configuration.nix
        nixos-hardware.nixosModules.raspberry-pi-4
        agenix.nixosModules.default
        # inputs.home-manager.nixosModules.default
      ];
    };
  };
}
