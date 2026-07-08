{
  description = "NixOS system flake (omnissiah)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    activate-linux.url = "github:MrGlockenspiel/activate-linux";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    minegrub-theme.url = "github:Lxtharia/minegrub-theme";
  };

  outputs = { self, nixpkgs, home-manager, minegrub-theme, nix-flatpak, activate-linux, ... }@inputs: {
    nixosConfigurations.omnissiah = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        nix-flatpak.nixosModules.nix-flatpak
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