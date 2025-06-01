{pkgs, ...}: {
  #Corrects previous prompt
  home.packages = with pkgs; [thefuck];
  programs.thefuck = {
    enable = true;
    enableZshIntegration = true;
  };
}
