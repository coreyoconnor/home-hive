{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options = {
    home-hive.useDefaultKernel = mkOption {
      default = true;
      type = with types; bool;
    };
  };
  config = mkIf config.home-hive.useDefaultKernel {
    boot = {
      kernelPackages = lib.mkDefault pkgs.linuxPackages_7_0;
      zfs.package = pkgs.zfs_2_4;
    };
  };
}
