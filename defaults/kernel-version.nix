{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  config = {
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_6_17;
  };
}

