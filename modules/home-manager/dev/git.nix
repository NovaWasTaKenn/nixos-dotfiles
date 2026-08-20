{
  config,
  pkgs,
  user,
  ...
}: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "quentin";
        email = "quentin.le-nestour@outlook.com";
      };
      push = {
        autoSetupRemote = true;
      };
      credential.helper = "${pkgs.git.override {withLibsecret = true;}}/bin/git-credential-libsecret";
      init.defaultBranch = "main";
      safe.directory = "/home/${user}/.dotfiles";
    };
  };
}
