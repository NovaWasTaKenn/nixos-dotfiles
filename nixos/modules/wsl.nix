
{pkgs, lib, inputs, config, builtins, ...}:

{  

  options.wsl = {
    defaultUser = lib.mkOption {
       type = lib.types.str;
       default = builtins.elemAt config.generalOptions.users 0; 
       description = "default wsl user";
      readOnly = true;
  
    };
  };

config = {

  imports = [ inputs.nixos-wsl.nixosModules.wsl ];
  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = config.wsl.defaultUser;
    startMenuLaunchers = true;

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;

  };

};
}
