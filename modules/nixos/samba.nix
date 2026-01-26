{ config, pkgs, ... }:

{
  # Enable Samba services
  services.samba = {
    enable = true;
    openFirewall = true;

    # Global Samba settings
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "smbnix";
        "netbios name" = "smbnix";
        "security" = "user";
        #"use sendfile" = "yes";
        #"max protocol" = "smb2";
        # note: localhost is the ipv6 localhost ::1
        "hosts allow" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
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

  systemd.tmpfiles.rules = [
    # Create the directory with correct ownership and permissions at boot
    "d /mnt/nas/data 0770 dejvid wheel - -"
  ];
}
