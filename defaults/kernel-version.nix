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
      zfs.package = pkgs.zfs_2_4;
      # kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_18.override {
      #   structuredExtraConfig = with lib.kernel; {
      #   };
      # };
    };
  };
}
