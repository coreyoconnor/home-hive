{
  options,
  pkgs,
  lib,
  ...
}:
with lib; {
  config = {
    services.resolved = {
      enable = true;
      settings.Resolve = {
        MulticastDNS = true;
        LMNR = true;
        Domains = [ "local" ];
      };
    };

    networking.firewall = {
      allowedUDPPorts = [ 5353 ];
    };

    services.avahi.enable = false;
  };
}
