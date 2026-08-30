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
        DNSSEC = true;
        DNSOverTLS = true;
      };
      settings.Resolve = {
        MulticastDNS = "no";
        LLMNR = "resolve";
      };
    };

    networking.firewall = {
      allowedUDPPorts = [ 5353 ];
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        workstation = true;
        userServices = true;
      };
    };
  };
}
