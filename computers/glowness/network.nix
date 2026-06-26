{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  localIPv4_0 = "192.168.88.18";
in {
  imports = [
    ../../network/home/default.nix
  ];

  config = {
    networking = {
      hostId = "4a571618";
      hostName = "glowness";
    };

    networking.firewall = {
      enable = false;
    };

    services.resolved = {
      settings.Resolve = {
        DNSSEC = true;
        DNSOverTLS = true;
      };
    };
  };
}
