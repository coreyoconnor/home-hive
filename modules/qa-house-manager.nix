{
  config,
  pkgs,
  nixpkgs-unstable,
  lib,
  ...
}:
with lib; let
  nixpkgs-unstable-pkgs = config.nixpkgs-unstable.pkgs;
in {
  options.services.qa-house-manager = {
    enable = mkOption {
      default = false;
      example = true;
      type = with types; bool;
    };
  };

  disabledModules = [
    "services/home-automation/home-assistant.nix"
  ];

  imports = [
    ./ring-mqtt.nix
    ./whisper-tts-and-stt.nix
    "${nixpkgs-unstable}/nixos/modules/services/home-automation/home-assistant.nix"
  ];

  config = mkIf config.services.qa-house-manager.enable {
    services.mosquitto = {
      enable = true;
      listeners = [
        {
          acl = ["pattern readwrite #"];
          omitPasswordAuth = true;
          settings.allow_anonymous = true;
        }
      ];
    };

    services.home-assistant = import ./qa-house-manager/home-assistant-service.nix {
      inherit config lib;
      pkgs = nixpkgs-unstable-pkgs;
    };

    # MQTT and postgresql
    networking.firewall.allowedTCPPorts = [ 1883 5432 58867 ];
    networking.firewall.allowedUDPPorts = [ 58866 ];

    nixpkgs = {
      config.permittedInsecurePackages = [
        "openssl-1.1.1w"
      ];
      overlays = [
        (self: super: {
          inherit (nixpkgs-unstable-pkgs) home-assistant;
        })
      ];
    };

    services.postgresql = {
      authentication = ''
        host all all 192.168.88.0/24 trust
        host all all 10.42.0.0/24 trust
        host all all 168.254.0.0/16 trust
      '';
      dataDir = "/var/lib/postgresql/14";
      enable = true;
      enableTCPIP = true;
      # listenAddresses = "192.168.88.4";
      enableJIT = true;
      ensureDatabases = ["hass"];
      ensureUsers = [
        {
          name = "hass";
          ensureDBOwnership = true;
        }
      ];
      package = pkgs.postgresql_14;
    };

    services.ring-mqtt.enable = true;

    systemd.services.postgresql.serviceConfig.TimeoutSec = lib.mkOverride 10 666;

    services.matter-server.enable = true;

    services.whisper-tts-and-stt.enable = true;

    users.users.hass = {
      linger = true;
      createHome = true;
      useDefaultShell = true;
      home = "/var/lib/hass";
      extraGroups = [
        "libvirtd"
        "users"
        "podman"
      ];
      subUidRanges = [
        {
          startUid = 2200000;
          count = 65536;
        }
      ];
      subGidRanges = [
        {
          startGid = 2200000;
          count = 65536;
        }
      ];
    };

    # USB bluetooth device reset
    services.udev.extraRules = ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2357", ATTRS{idProduct}=="0604", GROUP="users", MODE="0666"
    '';
  };
}
