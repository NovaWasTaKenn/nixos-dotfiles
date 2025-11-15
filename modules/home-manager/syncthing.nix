{
  pkgs,
  ...
}:  {
  home.packages = with pkgs; [syncthing];

  services.syncthing = {
    enable = true;
    
    settings = {
      folders = {
        "Documents" = {
          path = "/home/quentin/Documents";
        };
      };
    };
  };
}
