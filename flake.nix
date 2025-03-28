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
    pkgs = import inputs.nixpkgs {
      system = system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _:true;
      };
    };

    user = "quentin"; # TODO : multi users
    host = "desktop";

  in {
    homeConfigurations = {
      user = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [

          inputs.nvf.homeManagerModules.default
          # load home.nix from selected PROFILE
          (./. + "/profiles/users" + ("/" + user) + ".nix")
        ];
        extraSpecialArgs = {
          # pass config variables from above
          inherit inputs;
          inherit pkgs;
          inherit user;
          inherit host;
        };
      };
    };

    nixosConfigurations = {
      system = inputs.nixpkgs.lib.nixosSystem {
        system = system;
        modules = [
          (./. + "/profiles/hosts" + ("/" + host) + "/configuration.nix")
        ]; # load configuration.nix from selected PROFILE
        specialArgs = {
          # pass config variables from above
          inherit inputs;
          inherit system;
          inherit pkgs;
          inherit user;
          inherit host;
        };
      };
    };
  };
}
