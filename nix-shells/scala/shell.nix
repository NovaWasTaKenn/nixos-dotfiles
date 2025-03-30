{ pkgs, ...}:

{
      packages = with pkgs; [
        bloop
        sbt
        coursier
        scala-cli
        scalafmt
      ];

      #shellHook = '''';
      #ENV_VAR = "";
}

