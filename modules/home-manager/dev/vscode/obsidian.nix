{pkgs, ...}: let
  # Advanced URI community plugin (https://github.com/Vinzent03/obsidian-advanced-uri)
  # Required by the willasm.obsidian-md-vsc VSCode extension to communicate with Obsidian
  advancedUri = pkgs.linkFarm "obsidian-advanced-uri" [
    {
      name = "main.js";
      path = pkgs.fetchurl {
        url = "https://github.com/Vinzent03/obsidian-advanced-uri/releases/download/2.2.0/main.js";
        hash = "sha256-mCr9xhsi/7rJ/utexVg1YuISjl/I+9bp+JJ6UFoIpU4=";
      };
    }
    {
      name = "manifest.json";
      path = pkgs.fetchurl {
        url = "https://github.com/Vinzent03/obsidian-advanced-uri/releases/download/2.2.0/manifest.json";
        hash = "sha256-WMGwPpCfYicjs3grKRFBA2twchT7XwIN1uc7ADL4RYg=";
      };
    }
    {
      name = "styles.css";
      path = pkgs.fetchurl {
        url = "https://github.com/Vinzent03/obsidian-advanced-uri/releases/download/2.2.0/styles.css";
        hash = "sha256-8wKoLxNavlC8u1ZSPL6Xq0BSkKQ1hYIbjlLfTt5PRBc=";
      };
    }
  ];
in {
  programs.obsidian = {
    enable = true;

    defaultSettings = {
      # Fresh vaults start in restricted mode: let community plugins load
      app.restrictedMode = false;

      communityPlugins = [advancedUri];

      # WARNING: the obsidian module disables every core plugin not listed here.
      # This mirrors ~/Documents/personal/.obsidian/core-plugins.json as it was.
      corePlugins = [
        "file-explorer"
        "global-search"
        "switcher"
        "graph"
        "backlink"
        "canvas"
        "outgoing-link"
        "tag-pane"
        "page-preview"
        "templates"
        "note-composer"
        "command-palette"
        "editor-status"
        "bookmarks"
        "outline"
        "word-count"
        "file-recovery"
        "sync"
        "bases"
        # daily-notes is required by the obsidian-md-vsc VSCode extension
        {
          name = "daily-notes";
          settings.folder = "11-Daily";
        }
      ];
    };

    # Vaults to manage (target is relative to $HOME)
    vaults."Documents/personal" = {};
  };
}
