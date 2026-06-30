{
  config,
  lib,
  pkgs,
  nixpkgs-unstable,
  ...
}:
with lib; let
  nixpkgs-unstable-pkgs = nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  config = {
    services.ollama = {
      enable = true;
      package = nixpkgs-unstable-pkgs.ollama-cpu;
      openFirewall = true;
      host = "192.168.88.4";
      port = 11434;
    };
  };
}

