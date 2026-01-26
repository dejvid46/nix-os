{ pkgs, config, ... }: {

  age.secrets.wgPrivate = {
    file = ../../secrets/wg-private.age;
  };
  
  age.secrets.wgPsk = {
    file = ../../secrets/wg-psk.age;
  };

  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.13.13.5/32" ];
      dns = [ "10.13.13.1" ];
      privateKeyFile = config.age.secrets.wgPrivate.path;
      mtu = 1280;

      postUp = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o end0 -j MASQUERADE
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o wg0 -j MASQUERADE
      
        ${pkgs.iptables}/bin/iptables -t mangle -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
       '';

      # Undo the above
      postDown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o end0 -j MASQUERADE
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o wg0 -j MASQUERADE
      
        ${pkgs.iptables}/bin/iptables -t mangle -D FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
      '';
      
      peers = [
        {
          publicKey = "7erMpr41wvGGieoDUcB4ADMykjVRNYUC3E3C7L4Z1EY=";
          presharedKeyFile = config.age.secrets.wgPsk.path;
          allowedIPs = [ "10.13.13.0/29" ];
          endpoint = "185.223.31.38:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
