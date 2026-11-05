{
  host,
  pkgs,
  lib,
  ...
}: let
  isDesktop = host == "desktop";
in {
  # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # proxy.default = "http://user:password@proxy:port/";
  # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking = {
    hostName = "${host}";
    # Enable networking
    networkmanager.enable = true;
    firewall.enable = false;
    # Open ports in the firewall.
    firewall.allowedTCPPorts = [22];
    firewall.allowedUDPPorts = [69];
    firewall.allowedTCPPortRanges = [
      {
        from = 8000;
        to = 9000;
      }
    ];

    hosts = lib.mkIf isDesktop {
      "192.168.1.79" = ["*.pve.local"];
      "192.168.1.132" = ["node-3.pve.local" "homelab.pve.local"];
      "192.168.1.51" = ["node-4.pve.local"];
    };

    interfaces = lib.mkIf isDesktop {
      enp34s0 = {
        wakeOnLan.enable = true;
      };
    };
  };

  systemd.services.homelab-route = lib.mkIf isDesktop {
    description = "Static route to homelab vnet";
    after = ["network-online.target"];
    wants = ["network-online.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.iproute2}/bin/ip route replace 10.0.0.0/24 via 192.168.1.79 dev enp34s0";
      ExecStop = "${pkgs.iproute2}/bin/ip route del 10.0.0.0/24";
    };
  };

  services.resolved = {
    enable = true;
  };

  environment.etc = lib.mkIf isDesktop {
    "systemd/resolved.conf.d/pve.conf".text = ''
      [Resolve]
      DNS=192.168.1.79    # OPNsense WAN IP
      Domains=~pve.local
    '';
  };
}
