{ config, pkgs, ... }:

{
  age.secrets.stepcaPassword = {
    file = ../../../secrets/stepcaPassword.age;
    owner = "step-ca";
    group = "step-ca";
  };

  age.secrets.stepcaIntermediatePassword = {
    file = ../../../secrets/stepcaIntermediatePassword.age;
    owner = "step-ca";
    group = "step-ca";
  };

  services.step-ca = {
    enable = true;
    address = "127.0.0.1";
    port = 9000;
    
    intermediatePasswordFile = config.age.secrets.stepcaPassword.path;
  
    settings = let
      baseConfig = builtins.fromJSON (builtins.readFile ./ca.json);
    in baseConfig // {
      root = "${./certs/root_ca.crt}";
      crt = "${./certs/intermediate_ca.crt}";
      key = config.age.secrets.stepcaIntermediatePassword.path;

      db = {
        type = "badger";
        dataSource = "/var/lib/step-ca/db";
      };

      authority = baseConfig.authority // {
        provisioners = baseConfig.authority.provisioners ++ [
          { type = "ACME"; name = "acme"; }
        ];
      };
    };  
  };

  security.pki.certificateFiles = [
    "${./certs/root_ca.crt}"
  ];

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "admin@tvadomena.lan";
      
      server = "https://127.0.0.1:9000/acme/acme/directory";
    };
  };
}
