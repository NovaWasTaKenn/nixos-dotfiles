{
  config.vim.ui = {
    noice = {
      enable = true;
      setupOpts.routes = [
      {
        view = "notify";
        filter = { event = "msg_showmode";};
      } 
      ];
    };
  };
}
