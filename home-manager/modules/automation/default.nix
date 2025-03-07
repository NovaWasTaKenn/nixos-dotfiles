#From notAShelf dotfiles
{
  inputs,
  lib,
  ...
}: let
  inherit (builtins) filter map toString elem trace;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.strings) hasSuffix;
  inherit (lib.lists) concatLists;

  mkModule = {
    path,
    ignoredPaths ? [./plugins/sources/default.nix],
  }:
    filter (hasSuffix ".nix") (
      map toString (
        filter (path: path != ./default.nix && !elem path ignoredPaths) (listFilesRecursive path)
      )
    );

  module = trace ''${toString (mkModule {path = ./.;})}'' (mkModule {path = ./.;});
in {
  imports = concatLists [
    # construct this entire directory as a module
    # which means all default.nix files will be imported automatically
      module
  ];
}
