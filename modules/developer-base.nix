{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.developer-base;
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
