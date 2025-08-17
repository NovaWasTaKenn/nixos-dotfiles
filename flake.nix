{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvimConfigs = {
      url = "github:NovaWasTakenn/nvimConfigs/main";
      inputs.nixpkgs.follows = "nixpkgs"; # Suis le nixpkgs défini précédemment ou alors nixpkgs alias nix unstable ????
    };

    myCli = {
      url = "github:NovaWasTakenn/myCli/main";
      inputs.nixpkgs.follows = "nixpkgs"; # Suis le nixpkgs défini précédemment ou alors nixpkgs alias nix unstable ????
    };
  };

  outputs = inputs @ {self, ...}: let
    system = "x86_64-linux"; # Passer dans dossier profile / plus simple de laisser ici
    user = "quentin-pro"; # TODO : multi users
    host = "wsl";

    pkgs = import inputs.nixpkgs {
      system = system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _:true;
      };
      overlays = [
        (prev: final: {
          myBaseNvim = inputs.nvimConfigs.packages.${system}.baseNvim;
          dotfilesNvim = inputs.nvimConfigs.packages.${system}.dotfilesNvim;
          scalaNvim = inputs.nvimConfigs.packages.${system}.scalaNvim;
          myCli = inputs.myCli.packages.${system}.myCli;
        })
      ];
    };
  in {
    homeConfigurations = {
      user = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          # load home.nix from selected PROFILE
          (./. + "/profiles/users" + ("/" + user) + ".nix")
        ];
        extraSpecialArgs = {
          # pass config variables from above
          inherit inputs;
          inherit pkgs;
          inherit user;
          inherit host;
          inherit system;
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
