{
  description = "Ephemeral scala dev env";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nvimConfigs = {
      url = "path:../dev/neovim";
      inputs.nixpkgs.follows = "nixpkgs"; # Suis le nixpkgs défini précédemment ou alors nixpkgs alias nix unstable ????
    };
  };

  outputs = inputs @ {...}: let
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs {
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
        python313Packages.click
        python313Packages.cock
        pythonNvim
      ];

      shellHook = "echo 'Welcome to a python dev env'";
      #ENV_VAR = "";
    };

    packages.${system}.default = pkgs.python3Packages.buildPythonPackage rec {
      pname = "myPackage";
      version = "0.1.0";

      src = ./.;

      propagatedBuildInputs = [
        pkgs.python3Packages.click
      ];

      meta = with pkgs.lib; {
        description = "";
        homepage = "";
        license = licenses.mit;
        maintainers = with maintainers; [NovaWasTakenn];
      };
    };
  };
}
