{lib, ...}: {
  config = {
    generalOptions = {
      system = "x86_64-linux"; # Passer dans dossier profile / plus simple de laisser ici
      user = "quentin-pro"; # TODO : multi users
      host = "wsl";
    };
  };
}
