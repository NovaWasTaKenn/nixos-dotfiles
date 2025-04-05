{
  description = "Ephemeral scala dev env";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    pkgs = import nixpkgs { 
        system = "x86_64-linux";
        overlays = import ./overlays.nix;
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
      ];

      shellHook = "welcome to a scala dev shell";
      #ENV_VAR = "";
    };
  };
}
