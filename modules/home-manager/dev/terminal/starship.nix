{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [starship];
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      format = "[░▒▓](#a3aed2)[ ](bg:#a3aed2 fg:#090c0c)[](bg:#769ff0 fg:#a3aed2)$directory[](fg:#769ff0 bg:#272b33)$fill[](fg:#769ff0 bg:#272b33)$all$nix_shell$direnv[](bg:#769ff0 fg:#a3aed2)$time[▓▒░](#a3aed2)$line_break$character";

      fill = {
        symbol = " ";
        style = "";
        disabled = false;
      };

      python = {
        format = "[via $symbol$pyenv_prefix($version )(\($virtualenv\) )]($style)";
        style = "fg:#090c0c bg:#769ff0";
        disabled = false;
      };

      lua = {
        style = "fg:#090c0c bg:#769ff0";
        format = "[via $symbol($version )]($style)";
        disabled = false;
      };

      nix_shell = {
        style = "fg:#090c0c bg:#769ff0";
        symbol = "";
        format = "[via $symbol $state]($style)";
        disabled = false;
      };
      direnv = {
        symbol = "󱁏";
        allowed_msg = "";
        loaded_msg = "";
        unloaded_msg = "unloaded/";
        not_allowed_msg = "not allowed";
        denied_msg = "denied";
        format = "[$symbol $loaded$allowed ]($style)";
        style = "fg:#090c0c bg:#769ff0";
        disabled = false;
      };
      directory = {
        style = "fg:#090c0c bg:#769ff0";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = ".../";
        truncate_to_repo = true;
      };
      git_branch = {
        symbol = "";
        style = "bg:#769ff0";
        format = "[[ $symbol $branch ](fg:#090c0c bg:#769ff0)]($style)";
      };
      git_status = {
        style = "bg:#769ff0";
        format = "[[($all_status$ahead_behind )](fg:#090c0c bg:#769ff0)]($style)";
      };
      time = {
        disabled = false;
        time_format = "%R"; # Hour:Minute Format
        style = "bg:#1d2230";
        format = "[[  $time ](fg:#090c0c bg:#a3aed2)]($style)";
      };
      cmd_duration = {
        min_time = 15000;
        format = "[[ $duration ](fg:#090c0c bg:#769ff0)]($style)";
        style = "bg:#769ff0";
        show_milliseconds = false;
        disabled = false;
        show_notifications = false;
        min_time_to_notify = 45000;
      };

      os.disabled = true;
      memory_usage.disabled = false;
    };
  };
}
