{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ../../hardware/Gigabyte-X399-Aorus-Pro.nix
    ../../hardware/AMD-Ryzen-2920X.nix
    ../../network/home/host-glowness.nix
    ../../domains/primary
    ./audio.nix
    ./filesystems.nix
    ./memory.nix
    ./gpu.nix
    ./boot-banner.nix
  ];

  config = {
    networking.hostName = "glowness";
    system.stateVersion = "22.11";

    desktop = {
      enable = true;
      use-unstable-mesa = true;
    };
    developer-base.enable = true;

    environment.systemPackages = with pkgs; [
      chiaki
      piper
      valent
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
    hardware.spacenavd.enable = true;
    hardware.xpadneo.enable = true;

    networking.firewall = {
      enable = false;
    };

    nix = {
      extraOptions = ''
        keep-outputs = true
      '';
    };

    powerManagement.cpuFreqGovernor = "performance";

    programs.adb.enable = true;
    users.users.coconnor.extraGroups = ["adbusers"];

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      package = pkgs.steam.override {
        extraEnv = {
          GAMEMODERUN = "1";
          AMD_VULKAN_ICD = "RADV";
          PROTON_LOCAL_SHADER_CACHE = "1";
          MESA_SHADER_CACHE_MAX_SIZE = "16G";
          WINE_VK_VULKAN_ONLY = "1";
          WINEDLLOVERRIDES = "dinput8,dxgi,dsound=n,b";
        };
      };
    };

    # boot.initrd.systemd.tpm2.enable = false;
    security.tpm2.enable = true;

    services.foreign-binary-emulation.enable = true;
    services.kbfs.enable = true;

    virt-host.enable = true;

    virtualisation = {
      containers.enable = true;
      waydroid.enable = true;
    };
  };
}
