{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Required, nvf works best and only directly supports flakes
    nvf = {
      url = "github:notashelf/nvf";

      # You can override the input nixpkgs to follow your system's
      # instance of nixpkgs. This is safe to do as nvf does not depend
      # on a binary cache.
      inputs.nixpkgs.follows = "nixpkgs";
      # Optionally, you can also override individual plugins
      # for example:
      #inputs.obsidian-nvim.follows = "obsidian-nvim"; # <- this will use the obsidian-nvim from your inputs
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {self, ...}: let
    system = "x86_64-linux"; # Passer dans dossier profile
    user = "quentin"; # TODO : multi users
    pkgs = inputs.nixpkgs.config {
      system = system;
      allowUnfree = true;
      allowUnfreePredicate = (_:true);
    };
    specialArgs = {inherit inputs pkgs;};
    extraSpecialArgs = {inherit inputs pkgs;};
    host = "desktop";
  in {
    homeConfigurations = {
      user = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          # load home.nix from selected PROFILE
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = import (./. + "/profiles/users/" + ("/" + user) + ".nix");
            home-manager.extraSpecialArgs = extraSpecialArgs;
          }
        ];
        extraSpecialArgs = {
          # pass config variables from above
          inherit extraSpecialArgs;
        };
      };
    };

    nixosConfigurations = {
      system = pkgs.lib.nixosSystem {
        system = system;
        modules = [
          (./. + "/profiles/hosts" + ("/" + host) + "/configuration.nix")
        ]; # load configuration.nix from selected PROFILE
        specialArgs = {
          # pass config variables from above
          inherit specialArgs system;
        };
      };
    };
  };
}
