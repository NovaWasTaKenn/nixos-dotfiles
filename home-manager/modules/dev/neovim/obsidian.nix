{lib, ...}: {
  notes.obsidian = {
    enable = true;
    setupOpts = {
      completion.nvim_cmp = true;
      notes_subdir = "1O-Inbox";
      daily_notes = {
        folder = "11-Daily";
        dates_format = "%d-%m-%Y";
        default_tags = ["daily_notes"];
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
}
