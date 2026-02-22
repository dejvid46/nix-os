{ config, pkgs, ... }:

{
  # Povolit porty pro Nomad
  networking.firewall.allowedTCPPorts = [ 4646 4647 4648 ];
  networking.firewall.allowedUDPPorts = [ 4648 ];

  services.nomad = {
    enable = true;
    # Na RPi potřebujeme jen klientskou část
    settings = {
      client = {
        enabled = true;
        servers = ["192.168.1.10"]; # <--- IP TVÉHO DESKTOPU
        
        # Musíme namapovat NFS, aby Nomad viděl data
        # POZOR: Na RPi musíš NFS nejprve namountovat do systému!
        # Nomad na NixOS neřeší mountování NFS sám tak snadno jako K8s PV.
        host_volume = {
            uploads = { path = "/mnt/nfs/uploads"; read_only = false; };
            converted = { path = "/mnt/nfs/converted"; read_only = false; };
        };
      };
      plugin.docker.config.allow_privileged = true;
    };
  };
  
  # Mountování NFS na RPi (aby to Nomad viděl jako lokální složku)
  fileSystems."/mnt/nfs/uploads" = {
    device = "192.168.1.10:/srv/nfs/uploads";
    fsType = "nfs";
  };
  fileSystems."/mnt/nfs/converted" = {
    device = "192.168.1.10:/srv/nfs/converted";
    fsType = "nfs";
  };
}
