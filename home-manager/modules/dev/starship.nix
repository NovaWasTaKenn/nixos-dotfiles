{config, pkgs, ...}:

{
    programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
        add_newline = true;
        format = "$directory(:$username)$character";
        right_format = "$all";
        character = {
            success_symbol = "[>](bold green) ";
            error_symbol = "[>](bold red) ";
            };
            directory = {
                truncation_length = 3;
                truncation_symbol = ".../";
                truncate_to_repo = true;
            };
            os.disabled = false;
            memory_usage.disabled = false;
        };
        
    };

}

