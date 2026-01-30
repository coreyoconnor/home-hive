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
    version = "1.4.4";

    src = pkgs.fetchFromGitHub {
      owner = "MarcoGos";
      repo = "kleenex_pollenradar";
      rev = "2aebd549f81da345efa22927046517d36c38c39a";
      hash = "sha256-4yasiZUj7Nexqu5NAsjkDvbjkMlDffjcBmpltQ/Xu9U=";
    };

    propagatedBuildInputs = with pkgs.home-assistant.python.pkgs; [
      beautifulsoup4
    ];

    patches = [./kleenex_pollenradar.diff];
  };
in {
  enable = true;

  lovelaceConfig = import ./lovelace-config.nix;

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
  ];

  customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [
    card-mod
    apexcharts-card
    mini-graph-card
    lg-webos-remote-control
    mushroom
  ];

  extraPackages = ps:
    with ps; [
      cloudscraper
      psycopg2
      grpcio
      unidecode
    ];
}
