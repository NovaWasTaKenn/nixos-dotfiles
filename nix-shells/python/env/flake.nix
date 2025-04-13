{
  description = "Ephemeral python dev env";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nvimConfigs = {
      url = "path:../../modules/home-manager/dev/neovim";
      inputs.nixpkgs.follows = "nixpkgs"; # Suis le nixpkgs défini précédemment ou alors nixpkgs alias nix unstable ????
    };
  };

  outputs = inputs @ {...}: let
    system = "x86_64-linux";
    pkgs = import inputs.pkgs {
      system = system;
      overlays = [
        (final: prev: {
          pythonNvim = inputs.nvimConfigs.packages.${system}.pythonNvim;
        })
      ];
    };
  in {
    # importing package example
    # packages."x86_64-linux".default =
    #   pkgs.callPackage (import ./default.nix) {};

    devShells."x86_64-linux".default = pkgs.mkShell {
      packages = with pkgs; [
        python313
        #python313Packages.click
        #python313Packages.cock
        pythonNvim
      ];

      shellHook = "echo 'welcome to a python dev shell'";
      #ENV_VAR = "";
    };
  };
}
