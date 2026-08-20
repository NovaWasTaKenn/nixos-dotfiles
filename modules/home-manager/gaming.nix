{pkgs, ...}: {
  home.packages = with pkgs; [
    protonup-ng
    mangohud
    heroic
    steamtinkerlaunch
  ];

  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\\\${HOME}/.steam/root/compatibilitytools.d";
  };
}
