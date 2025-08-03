{
  config = {
    vim = {
      withPython3 = true;
      options = {
        tabstop = 2;
        shiftwidth = 2;
      };
      viAlias = false;
      vimAlias = true;
      statusline.lualine.enable = true;
      telescope.enable = true;
      autocomplete.nvim-cmp.enable = true;
      languages = {
        enableLSP = true;
        enableTreesitter = true;
        enableFormat = true;
      };
    };
  };
}
