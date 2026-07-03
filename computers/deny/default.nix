{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ../../hardware/lenovo-thinkpad-x1-7th-gen.nix
    ./boot-banner.nix
    ./filesystems.nix
    ./memory.nix
    ./power-management.nix
    ../../domains/primary
  ];

  config = {
    system.stateVersion = "23.05";

    networking = {
      extraHosts = ''
        192.168.88.4 ufo
        192.168.88.18 glowness
        192.168.88.23 deny
      '';
      hostName = "deny";
    };

    desktop.enable = true;
    developer-base.enable = true;

    environment.systemPackages = with pkgs; [
      android-tools
    ];

    hardware.bluetooth = {
      enable = true;
      settings = {
        General = {
          JustWorksRepairing = "confirm";
        };
      };
    };

    networking.firewall.enable = true;
    networking.enableIPv6 = true;

    users.users.coconnor.extraGroups = ["adbusers"];

    programs.captive-browser = {
      enable = true;
      interface = "wlp0s20f3";
    };

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };

    nix = {
      settings = {
        cores = 2;
        max-jobs = 2;
      };
    };

    services.foreign-binary-emulation.enable = true;
    services.kbfs.enable = true;

    virt-host.enable = true;

    virtualisation = {
      containers.enable = true;
      waydroid.enable = true;
    };

    # disable fingerprint auth for initial login to ensure keychain unlock
    programs.dconf.profiles.gdm.databases = [
      {
        settings."org/gnome/login-screen" = {
          enable-fingerprint-authentication = false;
        };
      }
    ];
  };
}
