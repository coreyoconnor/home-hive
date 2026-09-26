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
    voxtype.nixosModules.default
  ];
  config = mkIf cfg.enable {
    programs.voxtype = {
      enable = true;
      package = voxtype.packages.${pkgs.stdenv.hostPlatform.system}.onnx-migraphx;
    };

    environment.systemPackages = [
      voxtype.packages.${pkgs.stdenv.hostPlatform.system}.onnx-migraphx
      voxtype.packages.${pkgs.stdenv.hostPlatform.system}.osd-gtk4
    ];
  };
}
