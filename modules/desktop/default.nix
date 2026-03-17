{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.desktop;
in {
  imports = [
    ./speech-to-text.nix
    ./input-methods.nix
    ./locales.nix
  ];
}
