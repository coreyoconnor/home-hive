{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.desktop;
in {
  config = mkIf cfg.enable {
    services = {
      kanata = {
        enable = true;
        keyboards = {
          default.config = ''
            (defsrc)

            (deflayermap (base-layer)
              caps lctl
            )
          '';
        };
      };
    };
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";

      fcitx5 = {
        addons = with pkgs; [qt6Packages.fcitx5-chinese-addons];
        waylandFrontend = true;
      };
    };
  };
}
