{lib, ...}:{
  options = {
    generalOptions = {
      users = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "list of users for this config";
        readOnly = true;
  };
  };
};
}
