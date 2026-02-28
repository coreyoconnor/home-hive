{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.desktop;
in {
  config = mkIf cfg.enable {
    i8n.supportedLocales = [ "all" ];
  };
}
