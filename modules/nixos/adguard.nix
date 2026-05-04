{ config, pkgs, ... }: {
  services.adguardhome = {
    enable = true;
    port = 8081;

    settings = {
      dns = {
        upstream_dns = [ "8.8.8.8" "1.1.1.1" ];
        bind_hosts = [ "0.0.0.0" ];
        port = 53;

        rewrites = [
          { domain = "nextcloud.dejvid.pi"; answer = "192.168.88.35"; }
          { domain = "adguard.dejvid.pi"; answer = "192.168.88.35"; }
        ];
      };

      filtering = {
        protection_enabled = true;
        filtering_enabled = true;

        parental_enabled = false;
        safe_search = {
          enabled = false;
        };
      };

      filters = [
        {
          enabled = true;
          id = 1;
          name = "AdGuard DNS filter";
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
        }
        {
          enabled = true;
          id = 2;
          name = "StevenBlack Hosts";
          url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
        }
        {
          enabled = true;
          id = 3;
          name = "OISD (Big)";
          url = "https://big.oisd.nl";
        }
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [ 53 8081 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}
