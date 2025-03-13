{lib, pkgs, ...}: let
  #inherit (builtins) filter map toString;
  #inherit (lib.filesystem) listFilesRecursive;
  #inherit (lib.strings) hasSuffix fileContents;
  #inherit (lib.attrsets) genAttrs;
  #inherit (lib.nvim.dag) entryBefore;
in {
  imports = [
    ./plugins/git.nix
    ./plugins/mini.nix
    ./plugins/obsidian.nix
    ./plugins/binds.nix
    ./plugins/lsp.nix
    ./plugins/ui.nix
    ./plugins/extra.nix 
    ./plugins/harpoon.nix 
  ];

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
