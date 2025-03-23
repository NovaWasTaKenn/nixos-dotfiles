{lib, ...}: {
  imports = [
    ./starship.nix
    ./tmux.nix
    ./yazi.nix
    ./fzf.nix
    ./lazygit.nix
    ./zoxide.nix
  ];

  programs.zsh = {
    #zsh plugins

    enable = true;
    autocd = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = ".config/zsh";

    shellAliases = {
      # TODO: Move to a management script
      nrsd = "sudo nixos-rebuild switch --flake ./#system";
      nrsr = "sudo nixos-rebuild switch --flake ./#system --rollback";
      nrsu = "sudo nixos-rebuild switch --flake ./#system --update";
      hrsd = "sudo home-manager switch --flake ./#user";
      hrsr = "sudo home-manager switch --flake ./#user --rollback";
      hrsu = "sudo home-manager switch --flake ./#user --update";

      ls = "ls --color";
      ga = "git add";
      gc = "git commit -m";
      gs = "git status";
      gp = "git push";

      gps = "git pull";

      ff = "fuck";
    };

    history = {
      size = 10000;
      ignoreAllDups = true;
      ignoreDups = true;
      expireDuplicatesFirst = true;
      #ignorePatterns = ["rm *" "pkill *" "cp *"];
      ignoreSpace = true;
      path = "$HOME/.appdata/zsh_history";
      share = true;
      append = true;
    };

    historySubstringSearch = {
      enable = true;
      searchDownKey = ["^N"];
      searchUpKey = ["^P"];
    };

    initExtra = lib.strings.concatStringsSep "\n" [
      "zstyle ':completion:*' menu no"
      "zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'"
      "zstyle ':completion:*' matcher-list 'm:{A-Z}={A-Za-z}'"
      "zstyle ':completion:*' list-colors \"\${(s.:.)LS_COLORS}\""
      "zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color \$realpath'"
      "zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color \$realpath'"
      #Fix for fzf in vi insert mode. zsh-vim-mode needs to be cloned separately
      ''
        source $HOME/.config/zsh/zsh-vim-mode/zsh-vim-mode.plugin.zsh

        if [ -n ''\"''\${commands[fzf-share]}''\" ]; then
          source ''\"''\$(fzf-share)/key-bindings.zsh''\"
          source ''\"''\$(fzf-share)/completion.zsh''\"
        fi
      ''
    ];

    antidote = {
      enable = true;
      plugins = [
        "Aloxaf/fzf-tab"
        "ohmyzsh/ohmyzsh path:plugins/sudo"
        "ohmyzsh/ohmyzsh path:plugins/command-not-found"
      ];
    };
  };
}
