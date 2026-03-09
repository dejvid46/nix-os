{ config, pkgs, ... }: {

  age.secrets.nextcloudAdminPass = {
    file = ../../secrets/nextcloudPassword.age;
  };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31; 

    hostName = "nextcloud.dejvid.pi";

    https = false;

    database.createLocally = true;
    configureRedis = true;

    maxUploadSize = "16G";

    home = "/mnt/nas/data";

    config = {
      adminuser = "admin";
      adminpassFile = config.age.secrets.nextcloudPassword.path;
      dbtype = "pgsql";
    };

    settings = {
      trusted_domains = [ "nextcloud.dejvid.pi" "10.13.13.5" "192.168.88.35" ];
      
      default_phone_region = "CZ";
      
      "opcache.interned_strings_buffer" = 16;
    };
  };
}
