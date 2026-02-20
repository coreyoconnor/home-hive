{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  config = {
    boot = {
      kernelPackages = lib.mkDefault pkgs.linuxPackages_6_18;
      zfs.package = pkgs.zfs_unstable;
    };
  };
}
