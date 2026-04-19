{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options.services.ring-mqtt = {
    enable = mkOption {
      default = false;
      example = true;
      type = with types; bool;
    };
  };

  config = mkIf config.services.ring-mqtt.enable {
    virtualisation.oci-containers.containers = {
      # https://github.com/tsightler/ring-mqtt-ha-addon/blob/main/config.yaml
      ring-mqtt = {
        image = "tsightler/ring-mqtt:5.9.1";
        autoStart = true;
        user = "286:286";
        volumes = [
          "/mnt/storage/hass/ring-mqtt:/data"
        ];
        serviceName = "ring-mqtt";
        log-driver = "passthrough";
        extraOptions = [ "--network=host" ];
      };
    };

    systemd.services.ring-mqtt = {
      serviceConfig = {
        StandardOutput = "file:/var/log/ring-mqtt.log";
        StandardError = "file:/var/log/ring-mqtt.log";
      };
    };

    services.logrotate.settings."/var/log/ring-mqtt.log" = {
      daily = true;
      rotate = 7;
      compress = true;
      missingok = true;
      notifempty = true;
      copytruncate = true;
    };
  };
}
