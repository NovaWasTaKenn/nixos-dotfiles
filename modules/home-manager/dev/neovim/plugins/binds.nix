{
  config.vim.binds = {
    cheatsheet.enable = true;
    whichKey.enable = true;
  };

  config.vim.keymaps = [
    {
      key = "<leader>lfj";
      mode = "n";
      silent = false;
      action = ":%!jq .<CR>";
    }
  ];
}
