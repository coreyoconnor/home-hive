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
      keyd = {
        enable = true;
        keyboards = {
          default = {
            ids = ["*"];
            settings = {
              main = {
                capslock = "layer(capslock)";
              };

              "capslock:C" = {};
            };
          };
        };
      };
    };
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";

      fcitx5 = {
        addons = with pkgs; [ qt6Packages.fcitx5-chinese-addons ];
        waylandFrontend = true;
      };
    };
  };
}
