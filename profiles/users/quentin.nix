{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  configHome = "abc"; # equivalent to config.xdg.configHome
in {
  imports = [
    ./nova-pro.nix
  ];

}
