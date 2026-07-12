{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  nixpkgs-unstable-pkgs = config.nixpkgs-unstable.pkgs;
  cfg = config.desktop;
in {
  imports = [
  ];
  config = mkIf cfg.enable {
    programs.firefox.nativeMessagingHosts.packages = [ nixpkgs-unstable-pkgs.firefoxpwa ];
    environment.systemPackages = [ nixpkgs-unstable-pkgs.firefoxpwa ];
  };
}

