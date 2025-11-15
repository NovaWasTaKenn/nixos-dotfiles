{config, pkgs, user, ...}:

{
  programs.git = {
    enable = true;
    userName = "quentin";
    userEmail = "quentin.le-nestour@outlook.com";
    extraConfig = {
      credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
      init.defaultBranch = "main";
      safe.directory = "/home/${user}/.dotfiles";
    };
  };
}

