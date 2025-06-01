{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [yazi];
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      yazi = {
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
      };
    };
  };
}
