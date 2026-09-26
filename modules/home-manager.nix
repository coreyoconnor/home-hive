{
  config,
  pkgs,
  home-manager,
  lib,
  ...
}: {
  config = {
    environment.systemPackages = [
      home-manager.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
