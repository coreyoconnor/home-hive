{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = mkIf config.services.house-manager.enable {
    # Ensure the tun module and IPv6 packet forwarding are enabled
    boot.kernelModules = [ "tun" ];
    networking.enableIPv6 = true;

    services.openthread-border-router = {
      enable = true;
      openFirewall = true;
      backboneInterfaces = [ "enp179s0" ];
      interfaceName = "wpan0";
      rest.listenPort = 8081;
      web.listenPort = 8082;
      radio = {
        device = "/dev/serial/by-id/usb-SONOFF_SONOFF_Dongle_Max_MG24_64a6e6abf0edf011a56605a27632b0c4-if00-port0";
        baudRate = 115200;
      };
    };
  };
}

