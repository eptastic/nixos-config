# Main configuration file - now modularized
# This file imports and configures the various system modules
{
  config,
  lib,
  pkgs,
  ...
}: {
  # Import all modules
  imports = [
    ./modules/base-system.nix
    ./modules/pihole.nix
    ./modules/networking.nix
    ./modules/hardware.nix
    ./modules/users.nix
  ];

  # Enable all modules with default configuration
  pihole = {
    baseSystem.enable = false;
    service.enable = true;
    networking.enable = true;
    hardware.enable = false;
    users.enable = true;
  };

  # Module-specific customizations can be done here
  # For example:
  pihole.service = {
    interface = "ens3"; # Override default interface
    upstreamDNS = ["1.1.1.1" "1.0.0.1"];
    webPort = "80";
  };

  pihole.networking.hostName = "pihole-nix";
  pihole.networking.firewall.allowedTCPPorts = [22 53 80 443];
  pihole.networking.wifi.enable = false;
  pihole.baseSystem.timeZone = "Australia/Melbourne"; # Override default timezone

  users.users.root.openssh.authorizedKeys.keys = [
    # change this to your ssh key
    "ssh-rsa aaaab3nzac1yc2eaaaadaqabaaabaqduj8vrpbrbvxo6sbauvr9pfg45cv2cuzwe0dmqiaoldlrxuzetzfpc5wyfnc4jyufvo4vab8h1dmk1zwwiue2in+3x7rzixswybp+bwaycfiidnlhqgcgz/6j00lqhwjfb4jgf16pfmakocjzbw9bidjcyqpf6zyckwnykk88gcz6d+voheykze7zince4+9wj8gdwaxqifquknnsbqqo2modebojvziqhbttzb0zg21nyf6v9vi53srg5oe6cubu+l7d3qgdvurrqjyeejscm3r1c2bbw0s/da/odvy2acxiih02gurml2kjtxzma8as1diuxoz8bo4nw2ulyicax"
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.devices = ["/dev/sda"];

  system.stateVersion = "24.11";
}
