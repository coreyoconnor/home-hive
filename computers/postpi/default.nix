{
  config,
  pkgs,
  nixpkgs,
  lib,
  nixos-hardware,
  ...
}: {
  imports = [
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
    nixos-hardware.nixosModules.raspberry-pi-3
    ../../network/home
    ../../domains/primary
  ];

  config = {
    hardware.enableRedistributableFirmware = true;
    home-hive.useDefaultKernel = false;

    boot.kernel.sysctl = {
      "vm.swappiness" = 120;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
    };

    zramSwap.enable = true;
  };
}
