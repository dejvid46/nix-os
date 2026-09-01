{ config, pkgs, ... }: {

  age.secrets.nextcloudPassword = {
    file = ../../secrets/nextcloudPassword.age;
    mode = "0400";
    owner = "nextcloud";
    group = "nextcloud";
  };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;

    hostName = "nextcloud.dejvid.pi";
    https = true;

    database.createLocally = true;
    configureRedis = true;
    maxUploadSize = "16G";

    datadir = "/var/lib/nextcloud/data";

    phpOptions = {
      "memory_limit" = pkgs.lib.mkForce "512M";
      "opcache.interned_strings_buffer" = "16";
      "opcache.memory_consumption" = "128";
      "opcache.max_accelerated_files" = "10000";
      "opcache.revalidate_freq" = "1";
      "opcache.save_comments" = "1";
    };

    poolSettings = {
      "pm" = "dynamic";
      "pm.max_children" = "8";
      "pm.start_servers" = "2";
      "pm.min_spare_servers" = "1";
      "pm.max_spare_servers" = "3";
      "pm.max_requests" = "500";
    };

    config = {
      adminuser = "admin";
      adminpassFile = config.age.secrets.nextcloudPassword.path;
      dbtype = "pgsql";
    };

    settings = {
      trusted_domains = [ "nextcloud.dejvid.pi" "10.13.13.5" "192.168.88.35" ];
      default_phone_region = "CZ";

      preview_max_x = 1024;
      preview_max_y = 1024;
      jpeg_quality = 60;
    };
  };

  services.postgresql = {
    enable = true;
  };

  fileSystems."/var/lib/postgresql" = {
    device = "/mnt/nas/data/postgresql";
    options = [ "bind" ];
  };

  services.nginx.virtualHosts."nextcloud.dejvid.pi" = {
    forceSSL = true;
    enableACME = true;
  };
}
