{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [ghostty];
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
  };
}
