{
  systemd.user.services = {
    notify-notes-inbox-full = {
      Unit = {
        Description = "Checks how many notes are in each workspace inbox and notifies the user if too many are present";
      };
      Service = {
        Type = "oneshot";
        ExecStart = "/home/quentin/.dotfiles/modules/home-manager/automation/obsidian/notifyInboxFull.sh";
        TimeoutSec = 5;
      };
      Install = {
        WantedBy = ["default.target"];
      };
    };
  };
}
