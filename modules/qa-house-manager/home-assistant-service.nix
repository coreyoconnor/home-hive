{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  kleenex_pollenradar = pkgs.buildHomeAssistantComponent {
    owner = "MarcoGos";
    domain = "kleenex_pollenradar";
    version = "1.5.3";

    src = pkgs.fetchFromGitHub {
      owner = "MarcoGos";
      repo = "kleenex_pollenradar";
      rev = "d07d0c809071f9782c48ae92089687bffb1bcfb1";
      hash = "sha256-8b3wW49CGvOwLE2U0MZcoj3PINHhDDgjK2wYdTdifSw=";
    };

    propagatedBuildInputs = with pkgs.home-assistant.python.pkgs; [
      beautifulsoup4
    ];
  };

  magicattr = pkgs.home-assistant.python.pkgs.buildPythonPackage rec {
    pname = "magicattr";
    version = "0.1.6";
    format = "wheel";

    src = pkgs.home-assistant.python.pkgs.fetchPypi {
      inherit pname version format;
      hash = "sha256-2WsY7kW17oOwnBfhXTRZpk3mLVOICML3EYJ3fdnbu98=";
    };
  };

  gehomesdk-latest = pkgs.home-assistant.python.pkgs.gehomesdk.overrideDerivation (old: rec {
    version = "2026.2.0";

    src = pkgs.home-assistant.python.pkgs.fetchPypi {
      inherit (old) pname;
      version = "2026.2.0";
      hash = "sha256-+BWGkUDKd+9QGbdXuLjmJxLm1xUv0dpIRlPlDkUJ25w=";
    };
  });

  ha_gehome = pkgs.buildHomeAssistantComponent {
    owner = "simbaja";
    domain = "ge_home";
    version = "v2026.2.0";

    src = pkgs.fetchFromGitHub {
      owner = "simbaja";
      repo = "ha_gehome";
      rev = "60d82fb816806867dbcdb05579f56049d371dcf1";
      hash = "sha256-7c2GfTagNsIsSiT/sCqSV+BZZJMcvlsecDD+ZDZx9BA=";
    };

    propagatedBuildInputs = with pkgs.home-assistant.python.pkgs; [
      gehomesdk-latest
      magicattr
    ];
  };
in {
  enable = true;

  # lovelaceConfig = import ./lovelace-config.nix;

  config = {
    "automation ui" = "!include automations.yaml";

    binary_sensor = [
    ];

    camera = [
    ];

    # Includes dependencies for a basic setup
    # https://www.home-assistant.io/integrations/default_config/
    default_config = {};

    ffmpeg = {};

    homeassistant = {
      allowlist_external_dirs = [
        "/tmp"
        "/var/lib/hass/arlo/updates"
        "/var/lib/hass/arlo/media"
        "/mnt/storage/hass/arlo/media"
        "/mnt/storage/hass/arlo/updates"
      ];
      name = "Home";
      country = "US";
      latitude = "!secret home_latitude";
      longitude = "!secret home_longitude";
      elevation = "!secret home_elevation";
      radius = "100";
      time_zone = config.time.timeZone;
      unit_system = "us_customary";
      auth_providers = [
        {
          type = "trusted_networks";
          trusted_networks = [
            # lan network
            "192.168.88.0/24"
            "127.0.0.1"
          ];
          allow_bypass_login = false;
        }
        {
          type = "homeassistant";
        }
      ];

      media_dirs = {
        cameras = "/var/lib/hass/arlo/media";
      };
    };

    logger = {
      default = "info";
      logs = {};
    };

    media_player = [
    ];

    mobile_app = {};

    mqtt = {};

    recorder = {
      db_url = "postgresql://@/hass";
      purge_keep_days = 800;
    };

    sensor = [
    ];

    stream = {};

    system_health = {};

    template = [
    ];

    tts = [
      #{
      #  platform = "picotts";
      #}
    ];

    zeroconf = {};
  };

  extraComponents = import ./extra-components.nix {inherit config lib pkgs;};

  openFirewall = true;

  customComponents = [
    kleenex_pollenradar
    ha_gehome
  ];

  customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [
    card-mod
    apexcharts-card
    mini-graph-card
    lg-webos-remote-control
    mushroom
    apexcharts-card
    material-you-utilities
    zigbee2mqtt-networkmap
  ];

  extraPackages = ps:
    with ps; [
      cloudscraper
      psycopg2
      grpcio
      unidecode
    ];
}
