{
  systemd.user.timers = {
    notify-notes-inbox-full = {
      Unit = {
        Description = "Run notify-notes-inbox-full every 3h";
      };
      Timer = {
        Unit = "notify-notes-inbox-full.service";
        OnUnitActiveSec = "3hours";
        OnBootSec = "1min";
      };
      Install = {
        WantedBy = ["timers.target"];
      };
    };
  };
}
