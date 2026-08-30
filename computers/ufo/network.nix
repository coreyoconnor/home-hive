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
      useNetworkd = true;
      defaultGateway.interface = "192.168.88.1";
    };

    services.kubo.settings = {
      Addresses.API = "192.168.88.4";
    };

    services.nix-serve = {
      listenSockets = [
        "192.168.88.4:4999"
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

    services.avahi = {
      allowInterfaces = [ "enp179s0" ];
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

            # Allow established and related connections
            ct state { established, related } accept

            # Allow cross-interface forwarding for Thread / OTBR
            iifname "wpan0" oifname "enp179s0" accept
            iifname "enp179s0" oifname "wpan0" accept
          }
        }
      '';
    };

    systemd.network = {
      enable = true;

      networks = {
        "50-eno1" = {
          matchConfig.Name = "eno1";
          linkConfig.RequiredForOnline = "no";
        };
        "50-eno2" = {
          matchConfig.Name = "eno2";
          networkConfig = {
            DHCP = "yes";
          };
          linkConfig = {
            RequiredForOnline = "no";
          };
        };
        "50-enp179s0" = {
          matchConfig.Name = "enp179s0";
          networkConfig = {
            DHCP = "yes";
          };
          linkConfig = {
            RequiredForOnline = "yes";
          };
        };
      };
    };
  };
}
