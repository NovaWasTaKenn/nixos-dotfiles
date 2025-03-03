{
  binds = {
    cheatsheet.enable = true;
    whichKey.enable = true;
  };

  keymaps = [
    {
      key = "<leader>lfj";
      mode = "n";
      silent = false;
      action = ":%!jq .<CR>";
    }
    {
      key = "<leader>nsn";
      mode = "n";
      silent = false;
      action = ":ObsidianSearch<CR>";
    }
    {
      key = "<leader>nst";
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
      key = "<leader>nn";
      mode = "n";
      silent = false;
      action = ":ObsidianNew<CR>";
    }
    {
      key = "<leader>nqs";
      mode = "n";
      silent = false;
      action = ":ObsidianQuickSwitch<CR>";
    }
    {
      key = "<leader>ndt";
      mode = "n";
      silent = false;
      action = ":ObsidianToday<CR>";
    }

    {
      key = "<leader>ndd";
      mode = "n";
      silent = false;
      action = ":ObsidianTomorrow<CR>";
    }
    {
      key = "<leader>ndy";
      mode = "n";
      silent = false;
      action = ":ObsidianYesterday<CR>";
    }

    {
      key = "<leader>nda";
      mode = "n";
      silent = false;
      action = ":ObsidianDailies<CR>";
    }
  ];
}
