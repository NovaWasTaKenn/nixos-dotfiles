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

        git = {
          enable = true;
        };

        #mini = {
        #git.enable = true;
        #icon.enable = true;
        #};

        ui = {
          noice = {
            enable = true;
          };
        };

        binds = {
          cheatsheet.enable = true;
          whichKey.enable = true;
        };

        notes.obsidian = {
          enable = true;
          setupOpts = {
            completion.nvim_cmp = true;
            notes_subdir = "1O-Inbox";
            daily_notes = {
              folder = "11-Daily";
              dates_format = "%d-%m-%Y";
              default_tags = [ "daily_notes" ];
            };
            workspaces = [
              {
                name = "personal";
                path = "~/Documents/personal";
              }
              {
                name = "work";
                path = "~/Documents/personal";
              }
            ];
            #From obsidan.nvim github example config
            note_id_func = lib.generators.mkLuaInline ''
              function(title)
                   -- Create note IDs in a Zettelkasten format with a timestamp and a prefix.
                   -- In this case a note with the title 'My new note' will be given an ID that looks
                   -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
                   title = tostring(title)
                   local prefix = ""
                   if title ~= nil then
                     -- If title is given, transform it into valid file name.
                     prefix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
                   else
                     -- If title is nil, just add 4 random uppercase letters to the prefix.
                     for _ = 1, 4 do
                       prefix = prefix .. string.char(math.random(65, 90))
                     end
                   end
                   return prefix .. "-" .. tostring(os.time())
                 end
            '';
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
