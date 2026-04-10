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
    ./gaming.nix
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
      valent
    ];
    hardware.spacenavd.enable = true;

    networking.firewall = {
      enable = false;
    };

    nix = {
      extraOptions = ''
        keep-outputs = true
      '';
    };

    programs.adb.enable = true;
    users.users.coconnor.extraGroups = ["adbusers"];

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
