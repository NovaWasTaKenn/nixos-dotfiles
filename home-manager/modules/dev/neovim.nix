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
        keymaps = [
                {
                        key = "<leader>mp";
                        mode = ["n" "v"];
                        lua = true;
                        action = "function()
                                      conform.format({
                                        lsp_fallback = true,
                                        async = false,
                                        timeout_ms = 500,
                                      })
                                    end";
                        desc = "Format file or range (In visual mode)";
                }
        ];
    };
  };
};
}


