{ config, pkgs, lib, ... }:
let 
  config-volume = "/home/docker/pihole/";
in {
  systemd.tmpfiles.rules = [
    "d ${config-volume} 0755 999 999 -"
    # "d /var/lib/pihole/etc-dnsmasq 0755 999 999 -"
    "Z ${config-volume} 0755 999 999 -"
  ];

  users.groups.pihole.gid = 999;
  users.users.dejvid.extraGroups = [ "pihole" ];

  age.secrets.piholePassword.file = ../../secrets/piholePassword.age;

  virtualisation.oci-containers.containers.pihole = {
    image = "pihole/pihole:latest";
    autoStart = true;
    ports = [
      "53:53/tcp"
      "53:53/udp"
      "80:80/tcp"
      "443:443/tcp"
    ];
    environmentFiles = [ "/run/pihole-env-generated" ];
    environment = {
      TZ = "Europe/Prague";
      FTLCONF_dns_listeningMode = "all";
      FTLCONF_dns_upstreams = "8.8.8.8";
    };
    volumes = [
      "${config-volume}:/etc/pihole"
      # "/var/lib/pihole/etc-dnsmasq:/etc/dnsmasq.d"
    ];
    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--cap-add=SYS_TIME"
      "--cap-add=SYS_NICE"
    ];
  };

  systemd.services.docker-pihole.preStart = lib.mkAfter ''
    echo "FTLCONF_webserver_api_password=$(cat ${config.age.secrets.piholePassword.path})" > /run/pihole-env-generated
  '';
}
