{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    settings = {
      folders = {
        "Documents" = {
          path = "/home/quentin/Documents";
        };
      };
    };
  };
}
