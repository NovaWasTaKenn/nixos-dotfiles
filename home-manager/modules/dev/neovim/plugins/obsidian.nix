{
  lib,
  inputs,
  ...
}: let
  inherit (inputs.nvf.lib.nvim.dag) entryBefore;
in {
  programs.nvf.settings.vim = {
    luaConfigRC.addRequirePath = entryBefore ["lazyConfigs"] ''
      package.path = package.path .. ";" .. os.getenv("HOME") .. "/.dotfiles/home-manager/modules/dev/neovim/?.lua"
    '';
    notes.obsidian = {
      enable = true;
      setupOpts = {
        ui.enable = false;
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
            path = "~/Documents/work";
          }
        ];
        #From obsidan.nvim github example config
        note_id_func = lib.generators.mkLuaInline ''require("customLua.obsidian").noteIdFunc'';
      };
    };
    keymaps = [
      {
        key = "<leader>oss";
        mode = "n";
        silent = false;
        action = ":ObsidianSearch<CR>";
      }
      {
        key = "<leader>ost";
        mode = "n";
        silent = false;
        action = ":ObsidianTags<CR>";
      }

      {
        key = "<leader>fo";
        mode = "n";
        silent = false;
        action = ":ObsidianSearch<CR>";
      }
      {
        key = "<leader>on";
        mode = "n";
        silent = false;
        action = ":ObsidianNew<CR>";
      }
      {
        key = "<leader>oq";
        mode = "n";
        silent = false;
        action = ":ObsidianQuickSwitch<CR>";
      }
      {
        key = "<leader>odt";
        mode = "n";
        silent = false;
        action = ":ObsidianToday<CR>";
      }

      {
        key = "<leader>odd";
        mode = "n";
        silent = false;
        action = ":ObsidianTomorrow<CR>";
      }
      {
        key = "<leader>ody";
        mode = "n";
        silent = false;
        action = ":ObsidianYesterday<CR>";
      }

      {
        key = "<leader>oda";
        mode = "n";
        silent = false;
        action = ":ObsidianDailies<CR>";
      }
      {
        key = "<leader>ott";
        mode = "n";
        silent = false;
        action = ":lua require('customLua.obsidian').addTag('todo/checklist')<CR>";
      }
      {
        key = "<leader>otr";
        mode = "n";
        silent = false;
        action = ":lua require('customLua.obsidian').addTag('todo/rework')<CR>";
      }
      {
        key = "<leader>oti";
        mode = "n";
        silent = false;
        action = ":lua require('customLua.obsidian').addTag('todo/improvement')<CR>";
      }
      {
        key = "<leader>ots";
        mode = "n";
        silent = false;
        action = ":lua require('customLua.obsidian').addTag('todo/suggestion')<CR>";
      }
    ];
  };
}
