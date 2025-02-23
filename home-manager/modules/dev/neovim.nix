{config, pkgs, ...}:

{
  programs.nvf = {
    enable = true;
    # your settings need to go into the settings attribute set
    # most settings are documented in the appendix
    settings = {
      vim = {

        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
        };
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
          enableLSP= true;
          enableTreesitter = true;

          nix.enable = true;
          lua.enable = true;
        };

        lsp = {

          enable = true;
          formatOnSave = true;#doesnt work

          lspkind.enable = true;
          lsplines.enable = true;
          lightbulb.enable = true;
          lspSignature.enable = true;
        };
      };
    };
  };
}


