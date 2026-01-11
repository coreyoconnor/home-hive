{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ../../network/home
    ../../network/home/resource-media-server.nix
    ../../network/home/resource-user-share-server.nix
  ];
  config = {
    networking = {
      hostId = "abab4ab2";
      hostName = "ufo";
      useDHCP = true;
      enableIPv6 = false;
    };

    services.kubo.settings = {
      Addresses.API = "192.168.88.4";
    };

    services.nix-serve = {
      listenSockets = [
        "192.168.88.4:4999"
        "192.168.88.7:4999"
      ];
    };

    services.cloudflared = {
      enable = true;
      tunnels = {
        "uswest-0" = {
          credentialsFile = "/root/secrets/cloudflared-uswest-0-creds.json";
          default = "http_status:404";
        };
      };
    };

    networking.firewall = {
      allowedTCPPorts = [4999 9191 9091];
    };

    services.resolved = {
      dnssec = "true";
      dnsovertls = "true";
    };
  };
}
