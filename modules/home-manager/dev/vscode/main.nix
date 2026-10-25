{
  pkgs,
  config,
  ...
}: let
  marketplaceExtensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    # Obsidian MD for VSCode (Obsidian side is managed in ./obsidian.nix)
    {
      publisher = "willasm";
      name = "obsidian-md-vsc";
      version = "1.3.0";
      sha256 = "sha256-DBHhvJHakcdwzOkEm8hoOG1Kzkit3e/pdMT75dIyKhU=";
    }
    # Code Telescope: nvim telescope-like fuzzy finder
    {
      publisher = "guichina";
      name = "code-telescope";
      version = "1.11.3";
      sha256 = "sha256-QElgLQDZZORhOoJrrVfH5/ZvpF5gmPW4C0qdJZJGBuw=";
    }
  ];
in {
  imports = [./obsidian.nix];

  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions =
        (with pkgs.vscode-extensions; [
          dracula-theme.theme-dracula
          hashicorp.terraform
          skellock.just
          ms-python.python
          vscodevim.vim
          golang.go
          kamadorueda.alejandra
          bierner.github-markdown-preview
        ])
        ++ marketplaceExtensions;

      userSettings = {
        "workbench.colorTheme" = "Dracula";
        # Preseed the Obsidian MD extension (default note is asked on first connect)
        "obsidian-md-vsc.defaultVault" = "personal";
        "obsidian-md-vsc.defaultVaultPath" = "${config.home.homeDirectory}/Documents/personal";
      };

      # Simple key -> command binds only.
      # Both extensions also ship their own defaults:
      #   code-telescope: alt+m <key> finders (alt+m f files, alt+m g grep, ...)
      #   obsidian-md-vsc: alt+o connect with Obsidian
      keybindings = [
        {
          key = "ctrl+p";
          command = "code-telescope.fuzzy.file";
        }
        {
          key = "ctrl+shift+f";
          command = "code-telescope.fuzzy.wsText";
        }
        {
          key = "ctrl+alt+o";
          command = "obsidian-md-vsc.connect-with-vault";
        }
      ];
    };
  };
}
