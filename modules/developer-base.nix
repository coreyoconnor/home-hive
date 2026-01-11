{
  config,
  pkgs,
  lib,
  nixpkgs-unstable,
  ...
}:
with lib;
let
  cfg = config.developer-base;
  nixpkgs-unstable-pkgs = nixpkgs-unstable.legacyPackages.${pkgs.system};
in {
  options = {
    developer-base = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  imports = [
    ./developer
  ];
}
