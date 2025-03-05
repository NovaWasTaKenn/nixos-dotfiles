{
  programs.nvf.settings.vim.binds = {
    cheatsheet.enable = true;
    whichKey.enable = true;
  };

  programs.nvf.settings.vim.keymaps = [
    {
      key = "<leader>lfj";
      mode = "n";
      silent = false;
      action = ":%!jq .<CR>";
    }
  ];
}
