{ config, pkgs, lib, ...}:

{
    programs.tmux = 
    {
        enable = true;  
        keyMode = "vi";
        prefix = "C-Space";
        baseIndex = 1;
        escapeTime = 0;
        historyLimit = 10000;
        terminal = "tmux-256color";
        plugins = with pkgs; [
          #tmuxPlugins.sensible By default on nix package
          tmuxPlugins.vim-tmux-navigator
          tmuxPlugins.yank
          tmuxPlugins.catppuccin
          tmuxPlugins.tmux-floax
          #{
          #  plugin = tmuxPlugins.resurrect;
          #  extraConfig = "set -g @resurrect-strategy-nvim 'session'";
          #}
        ];

        extraConfig = lib.strings.concatStringsSep "\n" [
          "bind -n M-H previous-window"
          "bind -n M-L next-window"
          "bind-key -T copy-mode-vi v send-keys -X begin-selection"
          "bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle"
          "bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel"
          "bind '\"' split-window -v -c \"#{pane_current_path}\""
          "bind % split-window -h -c \"#{pane_current_path}\""

          #"set -g @catpuccin_flavour 'latte'"
          "set -g @floax-bind '-n M-p'" #root bind for tmux floax
        ]; 
    };
}
