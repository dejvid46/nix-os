{ config, pkgs, lib, ... }:
let
  config-volume = "/home/docker/baserow/";
in {
  systemd.tmpfiles.rules = [
    "d ${config-volume} 0755 9999 9999 -"
    "Z ${config-volume} 0755 9999 9999 -"
  ];

  users.groups.baserow.gid = 9999;
  users.users.dejvid.extraGroups = [ "baserow" ];

  age.secrets.baserowPassword.file = ../../secrets/baserowPassword.age;

  virtualisation.oci-containers.containers.baserow = {
    image = "baserow/baserow:latest";
    autoStart = true;
    ports = [
      "8080:80"
      # "8443:443"
    ];
    environmentFiles = [ "/run/baserow-env-generated" ];
    environment = {
      BASEROW_PUBLIC_URL = "http://localhost:8080";
      
      UID = "9999";
      GID = "9999";
    };
    volumes = [
      "${config-volume}:/baserow/data"
    ];
  };

  systemd.services.docker-baserow.preStart = lib.mkAfter ''
    echo "SECRET_KEY=$(cat ${config.age.secrets.baserowPassword.path})" > /run/baserow-env-generated
  '';
}
