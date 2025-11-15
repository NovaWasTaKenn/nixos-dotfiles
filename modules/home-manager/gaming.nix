{pkgs, ...}: {
  home.packages = with pkgs; [
    protonup
    mangohud
    lutris
    heroic
    bottles
    steamtinkerlaunch
    teamspeak6-client
    teamspeak3
  ];

  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\\\${HOME}/.steam/root/compatibilitytools.d";
  };
}
