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
    {
      key = "<leader>p";
      mode = "n";
      silent = false;
      action = ":bprevious<CR>";
    }
    {
      key = "<leader>n";
      mode = "n";
      silent = false;
      action = ":bnext<CR>";
    }
  ];
}
