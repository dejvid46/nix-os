{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [
    6443 # API Server
    10250 # Kubelet metrics
  ];
  networking.firewall.allowedUDPPorts = [
    8472 # Flannel VXLAN
  ];

  services.k3s = {
    enable = true;
    role = "agent";
    serverAddr = "https://192.168.88.253:6443";
    tokenFile = "/var/lib/rancher/k3s/server-token";
  };
}
