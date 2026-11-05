{
  pkgs,
  config,
  lib,
  host,
  ...
}: let
  isWork = host == "wsl";

  # Work machine runs native Windows VS Code (via the WSL Remote extension);
  # the nix-built Linux vscode binary doesn't run there, so its config is
  # pushed out to the real Windows profile instead of managed through
  # programs.vscode. See modules/nixos/wsl.nix for the /mnt automount.
  winUser = "qlenestour";
  winVscodeUserDir = "/mnt/c/Users/${winUser}/AppData/Roaming/Code/User";
  jsonFormat = pkgs.formats.json {};

  marketplaceExts = pkgs.vscode-utils.extensionsFromVscodeMarketplace;

  codeTelescopeExt = marketplaceExts [
    {
      publisher = "guichina";
      name = "code-telescope";
      version = "1.11.3";
      sha256 = "sha256-QElgLQDZZORhOoJrrVfH5/ZvpF5gmPW4C0qdJZJGBuw=";
    }
  ];

  autoHideExt = marketplaceExts [
    {
      publisher = "sirmspencer";
      name = "vscode-autohide";
      version = "1.0.10";
      sha256 = "sha256-8y4JvTfyYzYrlTjwYR2bJaWNVuYDI9pKLNVUxH2lJxU=";
    }
  ];

  obsidianExt = marketplaceExts [
    {
      publisher = "willasm";
      name = "obsidian-md-vsc";
      version = "1.3.0";
      sha256 = "sha256-DBHhvJHakcdwzOkEm8hoOG1Kzkit3e/pdMT75dIyKhU=";
    }
  ];

  # Installed on native Windows VS Code via its CLI (see home.activation
  # below) rather than through nix-built vscode-extensions derivations.
  workExtensionIds = [
    "dracula-theme.theme-dracula"
    "HashiCorp.terraform"
    "ms-python.python"
    "asvetliakov.vscode-neovim"
    "skellock.just"
    "ms-azuretools.vscode-bicep"
    "ms-vscode.powershell"
    "guichina.code-telescope"
    "sirmspencer.vscode-autohide"
    "willasm.obsidian-md-vsc"
  ];

  personalExtensions = with pkgs.vscode-extensions; [
    dracula-theme.theme-dracula
    hashicorp.terraform
    ms-python.python
    asvetliakov.vscode-neovim
    skellock.just
    golang.go
    redhat.ansible
    jnoortheen.nix-ide
  ];

  personalAllExtensions = personalExtensions ++ codeTelescopeExt ++ autoHideExt ++ obsidianExt;

  commonSettings = {
    "workbench.colorTheme" = "Dracula";
    "obsidian-md-vsc.defaultVault" = "personal";
    "obsidian-md-vsc.defaultVaultPath" = "${config.home.homeDirectory}/Documents/personal";
  };

  # Imported verbatim from the real Windows profile at
  # ${winVscodeUserDir}/settings.json so applying this is a no-op on day one.
  workSettings = {
    "terminal.integrated.persistentSessionScrollback" = 1000;
    "terminal.integrated.scrollback" = 10000;
    "workbench.colorTheme" = "Tiny Light";
    "files.watcherExclude" = {
      "**/.bloop" = true;
      "**/.metals" = true;
      "**/.ammonite" = true;
    };
    "editor.largeFileOptimizations" = false;
    "git.enableSmartCommit" = true;
    "python.defaultInterpreterPath" = "c:\\Users\\qlenestour\\AppData\\Local\\Programs\\Python\\Python311\\python.exe";
    "python.analysis.extraPaths" = [];
    "github.copilot.editor.enableAutoCompletions" = true;
    "editor.unicodeHighlight.invisibleCharacters" = false;
    "explorer.openEditors.visible" = 1;
    "python.createEnvironment.trigger" = "off";
    "editor.lineNumbers" = "relative";
    "zenMode.hideLineNumbers" = false;
    "github.copilot.nextEditSuggestions.enabled" = true;
    "terminal.integrated.stickyScroll.enabled" = false;
    "terraform.validation.enableEnhancedValidation" = false;
    "diffEditor.ignoreTrimWhitespace" = false;
    "workbench.secondarySideBar.defaultVisibility" = "hidden";
    "github.copilot.enable" = {
      "*" = false;
      "plaintext" = false;
      "markdown" = false;
      "scminput" = false;
      "python" = false;
      "html" = false;
    };
    "chat.tools.urls.autoApprove" = {
      "https://code.visualstudio.com" = true;
      "https://github.com/microsoft/vscode/wiki/*" = true;
      "https://kgateway.dev" = true;
      "https://learn.microsoft.com" = true;
      "https://*.microsoft.com" = true;
      "https://github.com/kubernetes-sigs" = true;
      "https://raw.githubusercontent.com/kubernetes-sigs" = true;
      "https://kubernetes.io" = true;
      "https://*.k8s.io" = true;
      "https://*.databricks.com" = true;
      "https://docs.solo.io" = true;
      "https://arxiv.org" = true;
    };
    "chat.viewSessions.orientation" = "stacked";
    "workbench.iconTheme" = "material-icon-theme";
    "chat.mcp.gallery.enabled" = true;
    "workbench.activityBar.location" = "hidden";
    "workbench.sideBar.location" = "right";
    "chat.tools.terminal.autoApprove" = {
      "/^python manage\\.py check$/" = {
        approve = true;
        matchCommandLine = true;
      };
      "/^git branch --show-current; git remote -v$/" = {
        approve = true;
        matchCommandLine = true;
      };
      "/^cd webapp; python manage\\.py test chatbot --verbosity=1$/" = {
        approve = true;
        matchCommandLine = true;
      };
    };
    "claudeCode.preferredLocation" = "panel";
    "github-enterprise.uris" = ["https://stime.ghe.com"];
    "claudeCode.hideOnboarding" = true;
  };

  # Imported verbatim from the real Windows profile at
  # ${winVscodeUserDir}/keybindings.json.
  workKeybindings = [
    {
      key = "ctrl+shift+oem_plus";
      command = "workbench.action.zoomOut";
    }
    {
      key = "ctrl+numpad_subtract";
      command = "-workbench.action.zoomOut";
    }
    {
      key = "ctrl+shift+oem_plus";
      command = "-workbench.action.zoomIn";
    }
    {
      key = "escape";
      command = "extension.vim_escape";
      when = "editorTextFocus && vim.active && !inDebugRepl";
    }
    {
      key = "ctrl+shift+i";
      command = "claudeVSCodeSidebar.focus";
    }
    {
      key = "ctrl+shift+alt+win+i";
      command = "workbench.action.chat.open";
      when = "!chatSetupDisabledInWorkspace && !chatSetupHidden";
    }
    {
      key = "ctrl+alt+i";
      command = "-workbench.action.chat.open";
      when = "!chatSetupDisabledInWorkspace && !chatSetupHidden";
    }
    {
      key = "ctrl+alt+u";
      command = "claude-vscode.editor.openLast";
      when = "!config.claudeCode.useTerminal";
    }
  ];

  telescopeKeybindings = [
    {
      key = "ctrl+p";
      command = "code-telescope.fuzzy.file";
    }
    {
      key = "ctrl+shift+f";
      command = "code-telescope.fuzzy.wsText";
    }
  ];

  obsidianKeybindings = [
    {
      key = "ctrl+alt+o";
      command = "obsidian-md-vsc.connect-with-vault";
    }
  ];
in {
  imports = [./obsidian.nix];

  programs.vscode = lib.mkIf (!isWork) {
    enable = true;
    profiles.default = {
      extensions = personalAllExtensions;
      userSettings = commonSettings;
      keybindings = telescopeKeybindings ++ obsidianKeybindings;
    };
  };

  home.activation = lib.mkIf isWork {
    vscodeWindowsSync = lib.hm.dag.entryAfter ["writeBoundary"] ''
      install -Dm644 ${jsonFormat.generate "vscode-work-settings.json" workSettings} \
        "${winVscodeUserDir}/settings.json"
      install -Dm644 ${jsonFormat.generate "vscode-work-keybindings.json" workKeybindings} \
        "${winVscodeUserDir}/keybindings.json"

      codeCli="/mnt/c/Users/${winUser}/AppData/Local/Programs/Microsoft VS Code/bin/code.cmd"
      if [ -x "$codeCli" ]; then
        installed=$("$codeCli" --list-extensions 2>/dev/null || true)
        for ext in ${lib.concatStringsSep " " workExtensionIds}; do
          if ! grep -qix "$ext" <<< "$installed"; then
            "$codeCli" --install-extension "$ext" --force || true
          fi
        done
      fi
    '';
  };
}
