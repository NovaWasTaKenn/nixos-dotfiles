{config, pkgs, ...}:

{
    programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
        add_newline = true;
        format = "[░▒▓](#a3aed2)[  ](bg:#a3aed2 fg:#090c0c)[](bg:#769ff0 fg:#a3aed2)$directory[](fg:#769ff0 bg:#272b33) $character";
        right_format = "[](fg:#769ff0 bg:#272b33)$all[](bg:#769ff0 fg:#a3aed2)$time[▓▒░](#a3aed2)";

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

