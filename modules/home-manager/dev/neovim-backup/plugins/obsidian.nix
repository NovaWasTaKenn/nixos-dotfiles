{
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib.nvim.dag) entryBefore;
in {
  config.vim = {
    luaConfigRC.addRequirePath = entryBefore ["lazyConfigs"] ''
      print(vim.inspect(package.path))
      package.path = package.path .. ";" .. os.getenv("HOME") .. "/.dotfiles/modules/home-manager/dev/neovim/?.lua"
    '';
    notes.obsidian = {
      enable = true;
      setupOpts = {
        ui.enable = false;
        completion.nvim_cmp = true;
        notes_subdir = "10-Inbox";
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
            path = "~/Documents/work";
          }
        ];
        #Custom logic
        #From obsidan.nvim github example config
        note_id_func = lib.generators.mkLuaInline ''require("customLua.obsidian").note_id_func'';
        note_frontmatter_func = lib.generators.mkLuaInline ''require("customLua.obsidian").note_frontmatter_func'';

        #Templates
        templates = {
          folder = "~/Documents/templates";
          date-format = "%a-%d-%m-%Y";
          time_format = "%H:%M";
        };
      };
    };

    keymaps = [
      # General keybinds
      {
        key = "<leader>oss";
        mode = "n";
        silent = false;
        action = ":ObsidianSearch<CR>";
        desc = "Obsidian search";
      }
      {
        key = "<leader>ost";
        mode = "n";
        silent = false;
        action = ":ObsidianTags<CR>";
        desc = "Obsidian tags";
      }
      {
        key = "<leader>fo";
        mode = "n";
        silent = false;
        action = ":ObsidianSearch<CR>";
        desc = "Obsidian search";
      }
      {
        key = "<leader>on";
        mode = "n";
        silent = false;
        action = ":ObsidianNew<CR>";
        desc = "Obsidian new note";
      }
      {
        key = "<leader>ov";
        mode = "n";
        silent = false;
        action = ":ObsidianQuickSwitch<CR>";
        desc = "Obsidian quick switch";
      }

      #Links
      {
        key = "<leader>olb";
        mode = "n";
        silent = false;
        action = ":ObsidianBacklinks<CR>";
        desc = "Obsidian backlinks";
      }
      {
        key = "<leader>oll";
        mode = "n";
        silent = false;
        action = ":ObsidianLinks<CR>";
        desc = "Obsidian links";
      }
      {
        key = "<leader>oln";
        mode = "n";
        silent = false;
        action = ":ObsidianLinksNew<CR>";
        desc = "Obsidian new link";
      }

      # Periodic notes keybinds
      {
        key = "<leader>opt";
        mode = "n";
        silent = false;
        action = ":lua require('customLua.obsidian').periodic_notes('daily', os.time())<CR>";
        desc = "Obsidian daily today";
      }
      {
        key = "<leader>opd";
        mode = "n";
        silent = false;
        action = ":lua require('customLua.obsidian').periodic_notes('daily', os.time()+86400)<CR>";
        desc = "Obsidian daily tomorrow";
      }
      {
        key = "<leader>opy";
        mode = "n";
        silent = false;
        action = ":lua require('customLua.obsidian').periodic_notes('daily', os.time()-86400)<CR>";
        desc = "Obsidian daily yesterday";
      }
      {
        key = "<leader>opm";
        mode = "n";
        silent = false;
        action = ":lua require('customLua.obsidian').periodic_notes('monthly', os.time())<CR>";
        desc = "Obsidian periodic monthly";
      }
      {
        key = "<leader>opw";
        mode = "n";
        silent = false;
        action = ":lua require('customLua.obsidian').periodic_notes('weekly', os.time())<CR>";
        desc = "Obsidian periodic weekly";
      }
      {
        key = "<leader>opa";
        mode = "n";
        silent = false;
        action = ":lua require('customLua.obsidian').periodic_notes('yearly', os.time())<CR>";
        desc = "Obsidian periodic yearly";
      }
      #Tags keybinds
      {
        key = "<leader>ot";
        mode = "n";
        silent = false;
        action = ":ObsidianTags<CR>";
        desc = "Obsidian search or add tags";
      }
      {
        key = "<leader>ott";
        mode = "n";
        silent = false;
        action = ":lua require('customLua.obsidian').addTag('todo/checklist')<CR>";
        desc = "Obsidian add todo/checklist tag";
      }
      {
        key = "<leader>oti";
        mode = "n";
        silent = false;
        action = ":lua require('customLua.obsidian').addTag('todo/improvement')<CR>";
        desc = "Obsidian add todo/improvement tag";
      }
      {
        key = "<leader>ots";
        mode = "n";
        silent = false;
        action = ":lua require('customLua.obsidian').addTag('todo/suggestion')<CR>";
        desc = "Obsidian add todo/suggestion tag";
      }

      # Frontmatter fields keybinds
      {
        key = "<leader>omq&";
        mode = "n";
        silent = false;
        action = '':lua require("customLua.obsidian").add_or_update_field("quality","raw")<CR>'';
        desc = "Obsidian make quality 'raw'";
      }
      {
        key = "<leader>omqé";
        mode = "n";
        silent = false;
        action = '':lua require("customLua.obsidian").add_or_update_field("quality","missing_informations")<CR>'';
        desc = "Obsidian make quality 'missing_informations'";
      }
      {
        key = ''<leader>omq"'';
        mode = "n";
        silent = false;
        action = '':lua require("customLua.obsidian").add_or_update_field("quality","missing_metadata")<CR>'';
        desc = "Obsidian make quality 'missing_metadata'";
      }
      {
        key = "<leader>omq'";
        mode = "n";
        silent = false;
        action = '':lua require("customLua.obsidian").add_or_update_field("quality","missing_formating")<CR>'';
        desc = "Obsidian make quality 'missing_formating'";
      }
      {
        key = "<leader>omq(";
        mode = "n";
        silent = false;
        action = '':lua require("customLua.obsidian").add_or_update_field("quality","final")<CR>'';
        desc = "Obsidian make quality 'final'";
      }
      {
        key = "<leader>oms&";
        mode = "n";
        silent = false;
        action = '':lua require("customLua.obsidian").add_or_update_field("status","prospective")<CR>'';
        desc = "Obsidian make status 'prospective'";
      }
      {
        key = "<leader>omsé";
        mode = "n";
        silent = false;
        action = '':lua require("customLua.obsidian").add_or_update_field("status","in progress")<CR>'';
        desc = "Obsidian make quality 'in progress'";
      }
      {
        key = ''<leader>oms"'';
        mode = "n";
        silent = false;
        action = '':lua require("customLua.obsidian").add_or_update_field("status","done")<CR>'';
        desc = "Obsidian make quality 'done'";
      }
      {
        key = ''<leader>oqn"'';
        mode = "n";
        silent = false;
        action = '':lua require("customLua.obsidian").quick_note()<CR>'';
        desc = "Obsidian quick note";
      }
      {
        key = ''<leader>oqc"'';
        mode = "n";
        silent = false;
        action = '':! tmux kill-window<CR>'';
        desc = "Obsidian quick note";
      }
    ];
  };
}
