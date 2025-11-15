{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [tmux];
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
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
      "bind -n M-h previous-window"
      "bind -n M-l next-window"

      "bind | split-window -h"
      "bind _ split-window -v"
      "unbind '\"'"
      "unbind %"

      "unbind u"
      "unbind i"
      "unbind o"
      "unbind p"

      "bind u select-window -t :1"
      "bind i select-window -t :2"
      "bind o select-window -t :3"
      "bind p select-window -t :4"

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
