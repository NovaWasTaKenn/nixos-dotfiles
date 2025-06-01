{pkgs, ...}: {
  #Better cd
  home.packages = with pkgs; [zoxide];
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
    ];
  };
}
