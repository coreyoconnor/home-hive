{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  xpadneoUdev = let
    rules0 = pkgs.fetchurl {
      url = "https://github.com/atar-axis/xpadneo/raw/refs/heads/master/hid-xpadneo/etc-udev-rules.d/60-xpadneo.rules";
      hash = "sha256-4K123m9BQeD/bJ9HVJlCiX3t/sI7UKSG9fZM6+TCgyI=";
    };
    rules1 = pkgs.fetchurl {
      url = "https://github.com/atar-axis/xpadneo/raw/refs/heads/master/hid-xpadneo/etc-udev-rules.d/70-xpadneo-disable-hidraw.rules";
      hash = "sha256-8/zC+7iPFZAGwiua6X0yW3CbGJRZSc8C71lnGN11RRQ=";
    };
  in
    pkgs.runCommand "collect-udev" {} ''
      mkdir -p $out/etc/udev/rules.d
      # avoid conflict with 60-steam
      cp ${rules0} $out/etc/udev/rules.d/61-xpadneo.rules
      cp ${rules1} $out/etc/udev/rules.d/70-xpadneo-disable-hidraw.rules
    '';
in {
  config = {
    boot.kernelModules = ["ntsync"];

    environment.systemPackages = with pkgs; [
      chiaki
      piper
      mangohud
    ];

    hardware.bluetooth = {
      enable = true;
      settings = {
        General = {
          JustWorksRepairing = "confirm";
        };
      };
    };
    hardware.xpadneo.enable = true;
    hardware.steam-hardware.enable = true;
    services.udev.packages = [
      xpadneoUdev
    ];

    powerManagement.cpuFreqGovernor = "performance";

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      package = pkgs.steam.override {
        extraEnv = {
          GAMEMODERUN = 1;
          AMD_VULKAN_ICD = "RADV";
          PROTON_LOCAL_SHADER_CACHE = 1;
          MESA_SHADER_CACHE_MAX_SIZE = "16G";
          WINE_VK_VULKAN_ONLY = 1;
          WINEDLLOVERRIDES = "dinput8,dxgi,dsound=n,b";
          PROTON_ENABLE_HDR = 1;
          PROTON_ENABLE_WAYLAND = 1;
          PROTON_USE_NTSYNC = 1;
          WAYLANDDRV_PRIMARY_MONITOR = "DP-2";
          # SDL_JOYSTICK_HIDAPI_XBOX_360 = 0;
          SDL_JOYSTICK_HIDAPI = 0;
        };
      };
    };
  };
}
