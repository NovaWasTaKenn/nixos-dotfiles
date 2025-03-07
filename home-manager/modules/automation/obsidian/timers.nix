{
  systemd.user.timers = {
    notify-notes-inbox-full = {
      Unit = {
        Description = "Run notify-notes-inbox-full every 3h";
      };
      Timer = {
        Persistent = true;
        Unit = "notify-notes-inbox-full.service";
        OnUnitActiveSec = 10800;
      };
      Install = {
        WantedBy = ["default.target"];
      };
    };
  };
}
