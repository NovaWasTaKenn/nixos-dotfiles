{
  description = "Ephemeral scala dev env";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nvimConfigs = {
      url = "github:NovaWasTaKenn/nvimConfigs/main";
      inputs.nixpkgs.follows = "nixpkgs"; # Suis le nixpkgs défini précédemment ou alors nixpkgs alias nix unstable ????
    };
  };

  outputs = inputs @ {...}: let
    system = "x86_64-linux";
    pkgs = import inputs.pkgs {
      system = system;
      overlays = [
        (final: prev: {
          sbt = prev.sbt.overrideAttrs {postPatch = "";};
        })

        (final: prev: {
          myBaseNvim = inputs.nvimConfigs.packages.${system}.baseNvim;
          dotfilesNvim = inputs.nvimConfigs.packages.${system}.dotfilesNvim;
          scalaNvim = inputs.nvimConfigs.packages.${system}.scalaNvim;
        })
      ];
    };
  in {
    # importing package example
    # packages."x86_64-linux".default =
    #   pkgs.callPackage (import ./default.nix) {};

    devShells."x86_64-linux".default = pkgs.mkShell {
      packages = with pkgs; [
        ammonite
        sbt
        coursier
        scala-cli
        scalafmt
        metals
        jdk23
        scalaNvim
      ];

      shellHook = "echo 'welcome to a scala dev shell'";
      #ENV_VAR = "";
    };
  };
}
