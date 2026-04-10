{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = {
    boot.kernelModules = [ "ntsync" ];

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
        };
      };
    };
  };
}

