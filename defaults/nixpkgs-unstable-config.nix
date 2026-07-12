{
  config,
  pkgs,
  nixpkgs-unstable,
  lib,
  options,
  ...
}:
with lib; let
  overlayType = lib.mkOptionType {
      name = "nixpkgs-overlay";
      description = "nixpkgs overlay";
      check = lib.isFunction;
      merge = lib.mergeOneOption;
    };
  overlaysDir = builtins.readDir ./nixpkgs-unstable/overlays;
  itemNames = attrNames overlaysDir;
  isImportable = f:
    builtins.match ".*\\.nix" f
    != null
    || pathExists (./nixpkgs-unstable/overlays + ("/" + f + "/default.nix"));
  overlays =
    map (f: import (./nixpkgs-unstable/overlays + ("/" + f)))
    (builtins.filter isImportable itemNames);
in {
  options = {
    nixpkgs-unstable = {
      overlays = mkOption {
        type = lib.types.listOf overlayType;
        default = overlays;
      };

      pkgs = mkOption {
        type = lib.types.pkgs;
        default = import nixpkgs-unstable {
          localSystem = pkgs.stdenv.buildPlatform.system;
          config = { };
          overlays = config.nixpkgs-unstable.overlays;
        };
      };
    };
  };
}
