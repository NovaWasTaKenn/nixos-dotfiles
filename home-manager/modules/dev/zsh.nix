{config, pkgs, lib, ...}:

{
    #Fuzzy finder
    programs.fzf = {
        enable = true;
        enableZshIntegration = true;
    };

    #Corrects previous prompt 
    programs.thefuck = {
        enable = true;
        enableZshIntegration = true;
    };

    #Better cd
    programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
        options = [

        ];
    };

    programs.zsh = {
        enable = true;
        autocd = true; 
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        dotDir = ".config/zsh";

        shellAliases = {
          nrsd = "sudo nixos-rebuild switch --flake ./#quentin-desktop";
          nrsr = "sudo nixos-rebuild switch --flake ./#quentin-desktop --rollback";
          nrsu = "sudo nixos-rebuild switch --flake ./#quentin-desktop --update";
          ls = "ls --color";
          ga = "git add";
          gc = "git commit -m";
          gs = "git status";
          gp = "git push";
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
            searchDownKey = [ "^N" ];
            searchUpKey = [ "^P" ];
        };
        
        initExtra = lib.strings.concatStringsSep "\n" [
            "zstyle ':completion:*' menu no" 
            "zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'"
            "zstyle ':completion:*' matcher-list 'm:{A-Z}={A-Za-z}'"
            "zstyle ':completion:*' list-colors \"\${(s.:.)LS_COLORS}\"" 
            "zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color \$realpath'" 
            "zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color \$realpath'" 
        ];
        
        antidote = {
            enable = true;
            plugins = [
                "Aloxaf/fzf-tab"  
                "ohmyzsh/ohmyzsh path:plugins/sudo"
                "ohmyzsh/ohmyzsh path:plugins/command-not-found"    
                "jeffreytse/zsh-vi-mode"
            ];
        };
    };


}