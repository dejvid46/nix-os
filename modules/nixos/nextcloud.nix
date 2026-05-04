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
    https = false;

    database.createLocally = true;
    configureRedis = true;
    maxUploadSize = "16G";

    datadir = "/var/lib/nextcloud/data";

    config = {
      adminuser = "admin";
      adminpassFile = config.age.secrets.nextcloudPassword.path;
      dbtype = "pgsql";
    };

    settings = {
      trusted_domains = [ "nextcloud.dejvid.pi" "10.13.13.5" "192.168.88.35" ];
      default_phone_region = "CZ";
    };

    phpOptions = {
      "opcache.interned_strings_buffer" = "16";
    };
  };
}
