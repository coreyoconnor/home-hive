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

    networking.nftables = {
      ruleset = ''
        table inet filter {
          chain input {
            type filter hook input priority 0; policy accept;

            # Block any local process from receiving on port 8080
            tcp dport 2269 drop
            udp dport 2269 drop
          }

          chain output {
            type filter hook output priority 0; policy accept;
          }

          chain forward {
            type filter hook forward priority 0; policy drop;
          }
        }
      '';
    };
  };
}
