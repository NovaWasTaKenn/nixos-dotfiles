{lib, ...}: {
  options = {
    generalOptions = {
      users = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "list of users for this config";
        readOnly = true;
      };
      system = lib.mkOption {
        type = lib.types.str;
        description = "System for this config";
        readOnly = true;
      };
      host = lib.mkOption {
        type = lib.types.str;
        description = "Host for this config";
        readOnly = true;
      };
    };
  };
}
