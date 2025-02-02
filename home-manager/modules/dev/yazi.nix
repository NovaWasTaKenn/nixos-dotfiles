{config, pkgs, lib, ...}:

{
    programs.yazi = {
        enable = true;
        enableZshIntegration = true;
        settings = {
            {
              log = {
                enabled = false;
              };
              manager = {
                ratio = [2 4 3];
                show_hidden = true;
                sort_by = "modified";
                sort_dir_first = true;
                sort_reverse = true;
              };
              
            }
        }
    }

}