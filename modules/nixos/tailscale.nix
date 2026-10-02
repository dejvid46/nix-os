{ config, pkgs, ... }: {
  services.tailscale.enable = true;

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ 41641 ];
  };

  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = "end0"; 
    internalInterfaces = [ "tailscale0" ];
  };

  systemd.services.tailscale-udp-gro = {
    description = "Vypnuti UDP GRO pro maximalni rychlost Tailscale";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.ethtool}/bin/ethtool -K end0 rx-udp-gro-forwarding off rx-gro-list off";
    };
  };
}
