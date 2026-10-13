{ config, pkgs, ... }: {


  services.nginx = {
    enable = true;
   
    virtualHosts."adguard.dejvid.pi" = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:8081"; 
        
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

          proxy_buffering off;
          proxy_request_buffering off;
        '';
      };
    };

    virtualHosts."ai.dejvid.pi" = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:20128";

        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

          proxy_buffering off;
          proxy_request_buffering off;
          proxy_cache off;
          proxy_set_header Connection "";
          proxy_http_version 1.1;
          chunked_transfer_encoding on;
          
          proxy_read_timeout 1000s; 
        '';
      };
    };
  };

  networking.hosts = {
    "127.0.0.1" = [ 
      "nextcloud.dejvid.pi"
      "adguard.dejvid.pi"
      "ai.dejvid.pi"
    ];
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ]; 
}
