{
  config,
  pkgs,
  lib,
  voxtype,
  ...
}:
with lib; let
  cfg = config.desktop;
in {
  imports = [
  ];
  config = mkIf cfg.enable {
    programs.firefox.nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
    environment.systemPackages = [ pkgs.firefoxpwa ];
  };
}

