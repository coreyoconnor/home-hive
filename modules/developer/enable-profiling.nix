{
  config,
  pkgs,
  lib,
  nixpkgs-unstable,
  ...
}:
with lib; let
  cfg = config.developer-base;
in {
  config = mkIf cfg.enable {
    boot.kernel.sysctl = {
      "kernel.perf_event_paranoid" = "-1";
    };
  };
}
