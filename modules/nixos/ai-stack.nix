{ config, pkgs, lib, ... }:
let
  headroom-volume = "/home/docker/headroom/";
  router-volume = "/home/docker/9router/";
in {
  age.secrets.aiStackEnv.file = ../../secrets/aiStackEnv.age;

  systemd.tmpfiles.rules = [
    "d ${headroom-volume} 0755 root root -"
    "d ${router-volume} 0755 root root -"
  ];

  virtualisation.oci-containers.containers = {
    headroom = {
      image = "ghcr.io/headroomlabs-ai/headroom:latest";
      autoStart = true;
      ports = [ "127.0.0.1:8787:8787" ];
      
      environmentFiles = [ config.age.secrets.aiStackEnv.path ];
      
      volumes = [ "${headroom-volume}:/app/data" ];
      cmd = [ "--host" "0.0.0.0" "--port" "8787" ];
    };

    "9router" = {
      image = "ghcr.io/decolua/9router:latest";
      autoStart = true;
      ports = [ "127.0.0.1:20128:20128" ];
      
      environmentFiles = [ config.age.secrets.aiStackEnv.path ];
      
      environment = {
        DATA_DIR = "/app/data";
        PORT = "20128";
        HOSTNAME = "0.0.0.0";
        HEADROOM_URL = "http://host.docker.internal:8787";
      };
      volumes = [ "${router-volume}:/app/data" ];
      dependsOn = [ "headroom" ];
    };
  };
}
