{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.boot.initrd.boot-banner;
in {
  options = {
    boot.initrd.boot-banner = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      banner = mkOption {
        type = types.path;
        default = true;
      };
    };
  };

  imports = [
  ];

  config = mkIf cfg.enable {
    boot = {
      initrd = {
        systemd = {
          storePaths = [ cfg.banner ];
          services.banner = {
            wantedBy = [ "initrd.target" ];
            serviceConfig = {
              Type = "oneshot";
              ExecStart = "/bin/cat ${cfg.banner}/banner.txt";
            };
          };
        };
      };
    };
  };
}

