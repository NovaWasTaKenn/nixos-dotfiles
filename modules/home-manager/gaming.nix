{ pkgs, ... }: {

  home.packages = with pkgs; [
    protonup
    mangohud
    lutris
    heroic
  ];

  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      ”\\\${HOME}/.steam/root/compatibilitytools.d”;
  };

}
