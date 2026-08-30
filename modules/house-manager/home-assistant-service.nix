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
    version = "1.6.4";

    src = pkgs.fetchFromGitHub {
      owner = "MarcoGos";
      repo = "kleenex_pollenradar";
      rev = "d802309e532e2dcf193da744f88636e4d86c5990";
      hash = "sha256-uLjjP3QNE61VGw/5hhKpfDz2Q+lDhzlebTundpcNqfY=";
    };

    propagatedBuildInputs = with pkgs.home-assistant.python3Packages; [
      beautifulsoup4
    ];
  };

  magicattr = pkgs.home-assistant.python3Packages.buildPythonPackage rec {
    pname = "magicattr";
    version = "0.1.6";
    format = "wheel";

    src = pkgs.home-assistant.python3Packages.fetchPypi {
      inherit pname version format;
      hash = "sha256-2WsY7kW17oOwnBfhXTRZpk3mLVOICML3EYJ3fdnbu98=";
    };
  };

  gehomesdk-latest = pkgs.home-assistant.python3Packages.gehomesdk.overrideDerivation (old: rec {
    version = "2026.8.0";

    src = pkgs.home-assistant.python3Packages.fetchPypi {
      inherit (old) pname;
      version = "2026.8.0";
      hash = "sha256-4WGkodI608LmlHpzYfPIrexZBNAsImmj2B55+WJgq2E=";
    };
  });

  ha_gehome = pkgs.buildHomeAssistantComponent {
    owner = "simbaja";
    domain = "ge_home";
    version = "v2026.8.0-dev0";

    src = pkgs.fetchFromGitHub {
      owner = "simbaja";
      repo = "ha_gehome";
      rev = "470471ad29eafaaa29f6041cf17090f5ea2dcbff";
      hash = "sha256-XU6w42gfZR0OfYDF/pYjrUfzufOYGwsX1s5oAMKk39I=";
    };

    propagatedBuildInputs = with pkgs.home-assistant.python3Packages; [
      gehomesdk-latest
      magicattr
    ];
  };

  petlibro = pkgs.buildHomeAssistantComponent {
    owner = "jjjonesjr33";
    domain = "petlibro";
    version = "v1.2.32";

    src = pkgs.fetchFromGitHub {
      owner = "jjjonesjr33";
      repo = "petlibro";
      rev = "e307919794b01173294939e7b9772fa04a1710d4";
      hash = "sha256-TOkh1uJgpDX2SQjeKZISU/t2e5tOW2wDUaDc+AESxRg=";
    };
  };

  lovelace-horizon-card =  pkgs.stdenv.mkDerivation rec {
    pname = "lovelace-horizon-card";
    version = "1.5.3";

    src = pkgs.fetchurl {
      url = "https://github.com/rejuvenate/lovelace-horizon-card/releases/download/v${version}/${pname}.js";
      hash = "sha256-dl9qDVzIfl6lVhAQr/EVWtYuUxhmZT9QkmBfLOk0VDM=";
    };

    builder = pkgs.writeShellScript "builder.sh" ''
      mkdir -p $out/
      cp $src $out/lovelace-horizon-card.js
    '';
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

    http = {
      server_host = "192.168.88.4";
    };

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

  extraComponents = import ./enabled-components.nix;

  openFirewall = true;

  customComponents = [
    kleenex_pollenradar
    ha_gehome
    petlibro
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
    lovelace-horizon-card
  ];

  extraPackages = ps:
    with ps; [
      cloudscraper
      psycopg2
      grpcio
      unidecode
    ];
}
