{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let 
  inherit (builtins) elemAt;
in {
  imports = [inputs.nixos-wsl.nixosModules.wsl];

  config = {
    wsl = {
      enable = true;
      automountPath = "/mnt";
      defaultUser = elemAt config.generalOptions.users 0;
      startMenuLaunchers = true;

      # Enable native Docker support
      # docker-native.enable = true;

      # Enable integration with Docker Desktop (needs to be installed)
      # docker-desktop.enable = true;
    };
  };
}
