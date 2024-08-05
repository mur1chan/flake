{
  description = "NixOS and Home Manager configuration as a flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
  };

  outputs = { nixpkgs, nixos-hardware, home-manager, ... }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        hostname = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos/configuration.nix
            ./nixos/hardware-configuration.nix
            ./nixos/luks.nix
            nixos-hardware.nixosModules.lenovo-thinkpad-t480s
          ];
        };
      };

      homeConfigurations = {
        username = home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          pkgs = import nixpkgs { inherit system;};
          modules = [ ./home-manager/home.nix ];
        };
      };
    };
}

