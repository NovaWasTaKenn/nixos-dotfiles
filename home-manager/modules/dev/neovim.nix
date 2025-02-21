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
        };
        viAlias = false;
        vimAlias = true;
        lsp = {
          enable = true;
        };
        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;

        languages = {
          enableLSP= true;
          enableTreesitter = true;

          nix.enable = true;
        };
        formatter.conform-nvim.setupOpts = {
                        formatter_by_ft = {
                                nix = ["alejandra"];
                         
                                markdown = ["prettier"];
                                json = ["prettier"];
                                     
                        };
                        format_on_save = {
                                lsp_format = "fallback";
                                timeout_ms = 500;
                        };
        
      };
    };
  };
};
}


