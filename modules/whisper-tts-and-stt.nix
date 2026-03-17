{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options.services.whisper-tts-and-stt = {
    enable = mkOption {
      default = false;
      example = true;
      type = with types; bool;
    };
  };

  config = mkIf config.services.whisper-tts-and-stt.enable {
    virtualisation.oci-containers.containers = {
      whisper-stt = {
        image = "rhasspy/wyoming-whisper:3.1.0";
        cmd = [ "--compute-type" "int8" "--model" "tiny-int8" "--language" "en" ];
        ports = [ "10300:10300" ];
        autoStart = true;
        volumes = [
          "/mnt/storage/hass/whisper-stt:/data"
        ];
        serviceName = "whisper-stt";
        log-driver = "passthrough";
      };

      # https://github.com/rhasspy/wyoming-piper
      whisper-tts = {
        image = "rhasspy/wyoming-piper:2.2.2";
        cmd = [ "--voice" "en_US-lessac-medium" ];
        ports = [ "10200:10200" ];
        user = "286:286";
        autoStart = true;
        volumes = [
          "/mnt/storage/hass/whisper-tts:/data"
        ];
        serviceName = "whisper-tts";
        log-driver = "passthrough";
      };
    };

    systemd.services.whisper-tts = {
      serviceConfig = {
        StandardOutput = "file:/var/log/whisper-tts.log";
        StandardError = "file:/var/log/whisper-tts.log";
      };
    };

    services.logrotate.settings."/var/log/whisper-tts.log" = {
      daily = true;
      rotate = 7;
      compress = true;
      missingok = true;
      notifempty = true;
      copytruncate = true;
    };

    systemd.services.whisper-stt = {
      serviceConfig = {
        StandardOutput = "file:/var/log/whisper-stt.log";
        StandardError = "file:/var/log/whisper-stt.log";
      };
    };

    services.logrotate.settings."/var/log/whisper-stt.log" = {
      daily = true;
      rotate = 7;
      compress = true;
      missingok = true;
      notifempty = true;
      copytruncate = true;
    };
  };
}

