{
  description = "NixOS system flake (omnissiah)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    minegrub-theme.url = "github:Lxtharia/minegrub-theme";
  };

  outputs = { self, nixpkgs, home-manager, minegrub-theme, ... }:
  {
    nixosConfigurations.omnissiah = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix

        minegrub-theme.nixosModules.default

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.darthunder = import ./home.nix;
        }
      ];
    };
  };
}