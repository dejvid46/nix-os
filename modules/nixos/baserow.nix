{ config, pkgs, lib, ... }:
let
  config-volume = "/home/docker/baserow/";
in {
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
      BASEROW_PUBLIC_URL = "http://192.168.88.35:8080";
      
    };
    volumes = [
      "${config-volume}:/baserow/data"
    ];
  };

  systemd.services.docker-baserow.preStart = lib.mkAfter ''
    echo "SECRET_KEY=$(cat ${config.age.secrets.baserowPassword.path})" > /run/baserow-env-generated
  '';
}
