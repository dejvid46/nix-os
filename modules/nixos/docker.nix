{ config, pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
    liveRestore = false;
  };

  virtualisation.oci-containers.backend = "docker";

  imports = [
    ./pihole.nix
  ];
}
