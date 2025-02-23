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

        formatter.conform-nvim = {
          enable = true;
          setupOpts = {
                                                                                  formatters_by_ft = {
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
        keymaps = [
                {
                        key = "<leader>mp";
                        mode = ["n" "v"];
                        action = ":lua require('conform').format({lsp_fallback = true,async = false,timeout_ms = 500})<CR>";
                        desc = "Format file or range (In visual mode)";
                }
        ];

        #        extraPlugins =  {
        #          conform = {
        #           package = "conform-nvim";
        #            setup = "local conform = require('conform').setup {['default_format_opts'] = {['lsp_format'] = 'fallback'},['format_after_save'] = {['lsp_format'] = 'fallback'},['format_on_save'] = {['lsp_format'] = 'fallback',['timeout_ms'] = 500},['formatters_by_ft'] = {['json'] = {'prettier'},['markdown'] = {'prettier'},['nix'] = {'alejandra'}}}";
        #          };
        #        };
    };
  };
};
}


