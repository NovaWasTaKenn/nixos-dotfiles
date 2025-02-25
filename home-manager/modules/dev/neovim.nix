{lib, ...}: let
  #inherit (builtins) filter map toString;
  #inherit (lib.filesystem) listFilesRecursive;
  #inherit (lib.strings) hasSuffix fileContents;
  #inherit (lib.attrsets) genAttrs;
  #inherit (lib.nvim.dag) entryBefore;
in {
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
          enableLSP = true;
          enableTreesitter = true;
          enableFormat = true;
          nix.enable = true;
          lua.enable = true;
        };
        lsp = {
          enable = true;
          lspkind.enable = true;
          lsplines.enable = true;
          lightbulb.enable = true;
          lspSignature.enable = true;
        };

        notes.obsidian = {
          enable = true;
          setupOpts = {
            completion.nvim_cmp = true;
            daily_notes.dates_format = "%d/%m/%Y";
          };
        };

        keymaps = [
          {
            key = "<leader>lfj";
            mode = "n";
            silent = false;
            action = ":%!jq .<CR>";
          }
        ];

        #luaConfigRC = let
        ## get the name of each lua file in the lua directory, where setting files reside
        ## and import tham recursively
        #configPaths = filter (hasSuffix ".lua") (map toString (listFilesRecursive ./lua));
        #
        ## generates a key-value pair that looks roughly as follows:
        ##  `<filePath> = entryAnywhere ''<contents of filePath>''`
        ## which is expected by nvf's modified DAG library
        #luaConfig = genAttrs configPaths (file:
        #entryBefore ["luaScript"] ''
        #${fileContents file}
        #'');
        #in
        #  luaConfig;
      };
    };
  };
}
