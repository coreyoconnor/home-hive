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
    ../../domains/primary
    ./audio.nix
    ./filesystems.nix
    ./memory.nix
    ./gpu.nix
    ./boot-banner.nix
    ./gaming.nix
    ./network.nix
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
      android-tools
    ];
    hardware.spacenavd.enable = true;

    nix = {
      extraOptions = ''
        keep-outputs = true
      '';
    };

    programs.fuse.enable = true;

    users.users.coconnor.extraGroups = ["adbusers"];

    # boot.initrd.systemd.tpm2.enable = false;
    security.tpm2.enable = true;

    services.foreign-binary-emulation.enable = true;
    services.kbfs.enable = true;
    services.kmscon.enable = false;

    virt-host.enable = true;

    virtualisation = {
      containers.enable = true;
      waydroid.enable = true;
    };
  };
}
