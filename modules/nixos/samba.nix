{ config, pkgs, ... }:

{
  # Enable Samba services
  services.samba = {
    enable = true;
    openFirewall = true;

    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "smbnix";
        "netbios name" = "smbnix";
        "security" = "user";
        #"use sendfile" = "yes";
        "hosts allow" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";

        "min receivefile size" = "16384";
        "use sendfile" = "yes";
        "aio read size" = "16384";
        "aio write size" = "16384";
        
        "socket options" = "TCP_NODELAY IPTOS_LOWDELAY SO_RCVBUF=131072 SO_SNDBUF=131072";
        
        "server min protocol" = "SMB3";
      };

      # "public" = {
      #   "path" = "/mnt/nas/data";
      #   "browseable" = "yes";
      #   "read only" = "no";
      #   "guest ok" = "no";
      #   "create mask" = "0644";
      #   "directory mask" = "0755";
      #   "force user" = "username";
      #   "force group" = "groupname";
      # };

      "data" = {
        "path" = "/mnt/nas/data";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "dejvid";
        "force group" = "wheel";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  systemd.tmpfiles.rules = [
    # Create the directory with correct ownership and permissions at boot
    "d /mnt/nas/data 0770 dejvid wheel - -"
  ];
}
