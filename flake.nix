{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
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
    # One entry per machine, select at build time:
    #   sudo nixos-rebuild switch --flake .#<host>
    hosts = {
      desktop = {
        system = "x86_64-linux";
        user = "quentin";
      };
      wsl = {
        system = "x86_64-linux";
        user = "quentin-pro";
      };
    };

    nixpkgsConfig = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "qtwebengine-5.15.19"
      ];
    };

    mkOverlays = system: [
      (prev: final: {
        myBaseNvim = inputs.nvimConfigs.packages.${system}.baseNvim;
        dotfilesNvim = inputs.nvimConfigs.packages.${system}.dotfilesNvim;
        scalaNvim = inputs.nvimConfigs.packages.${system}.scalaNvim;
        myCli = inputs.myCli.packages.${system}.myCli;
      })
    ];

    mkNixos = host: {
      system,
      user,
    }: let
      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config =
          nixpkgsConfig
          // {
            allowUnfreePredicate = _: true;
          };
        overlays = mkOverlays system;
      };
    in
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          # pass config variables to host modules
          inherit inputs;
          inherit system;
          inherit user;
          inherit host;
          inherit pkgs-unstable;
        };
        modules = [
          inputs.home-manager.nixosModules.home-manager
          {
            nixpkgs.config = nixpkgsConfig;
            nixpkgs.overlays = mkOverlays system;
          }
          (./. + "/profiles/hosts/${host}/configuration.nix")
        ];
      };
  in {
    nixosConfigurations = inputs.nixpkgs.lib.mapAttrs mkNixos hosts;
  };
}
