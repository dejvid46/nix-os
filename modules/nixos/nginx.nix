{ config, pkgs, ... }: {


  services.nginx = {
    enable = true;
    
    virtualHosts."pihole.dejvid.pi" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8081"; 
        
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_addrs;
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 ]; 
}
