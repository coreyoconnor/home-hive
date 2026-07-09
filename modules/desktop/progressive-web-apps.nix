{
  config,
  pkgs,
  nixpkgs-unstable,
  lib,
  ...
}:
with lib; let
  nixpkgs-unstable-pkgs = nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  cfg = config.desktop;
in {
  imports = [
  ];
  config = mkIf cfg.enable {
    programs.firefox.nativeMessagingHosts.packages = [ nixpkgs-unstable-pkgs.firefoxpwa ];
    environment.systemPackages = [ nixpkgs-unstable-pkgs.firefoxpwa ];
  };
}

