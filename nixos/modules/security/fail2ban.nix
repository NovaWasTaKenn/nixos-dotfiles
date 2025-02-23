{
  services.fail2ban = {

    enable = true;
    # Ban IP after 5 failures
    maxretry = 5;
    ignoreIP = [
      # Whitelist some subnets
    ];



    bantime = "1h"; # Ban IPs for one hour on the first ban
    bantime-increment = {
      enable = true; # Enable increment of bantime after each violation
      formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
      factor = "8";

      overalljails = true; # Calculate the bantime based on all the violations
    };
  };
}
