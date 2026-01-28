{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  hostname = "pi";
  user = "dejvid";

  timeZone = "Europe/Prague";
  defaultLocale = "en_US.UTF-8";

  mySecretList = [ 
    "userPassword"
  ];
in {

  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/docker.nix
    ../../modules/nixos/wireguard.nix
    ../../modules/nixos/samba.nix
    ../../modules/nixos/kubernetes.nix
  ];

  networking.hostName = hostname;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    vim
    tcpdump
    btrfs-progs
    htop
    iftop
    lm_sensors
    tcptrack
    tmux
    git

    inputs.agenix.packages.${pkgs.system}.default
  ];

  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  age.secrets = lib.genAttrs mySecretList (name: {
    file = ../../secrets/${name}.age;
    
    # owner = "dejvid"; 
  });

  services.openssh.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 
      80 443 53 445 139  # Your existing ports
      2377               # Docker Swarm: Cluster Management
      7946               # Docker Swarm: Node Communication
    ];
    allowedUDPPorts = [ 
      53 137 138         # Your existing ports
      7946               # Docker Swarm: Node Communication
      4789               # Docker Swarm: Overlay Network Traffic (Critical for rabbitmq connection)
    ];
    
    # CRITICAL: Docker Swarm overlay networks (vxlan) often fail on NixOS 
    # due to strict reverse path filtering. This allows the traffic to flow.
    checkReversePath = false;
  };

  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  time.timeZone = timeZone;

  i18n = {
    defaultLocale = defaultLocale;
    extraLocaleSettings = {
      LC_ADDRESS = defaultLocale;
      LC_IDENTIFICATION = defaultLocale;
      LC_MEASUREMENT = defaultLocale;
      LC_MONETARY = defaultLocale;
      LC_NAME = defaultLocale;
      LC_NUMERIC = defaultLocale;
      LC_PAPER = defaultLocale;
      LC_TELEPHONE = defaultLocale;
      LC_TIME = defaultLocale;
    };
  };

  users = {
    mutableUsers = false;
    users."${user}" = {
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets.userPassword.path;
      extraGroups = [ "wheel" ];
    };
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };

  # Enable GPU acceleration
  hardware.raspberry-pi."4".fkms-3d.enable = true;

  system.stateVersion = "23.11";

}
