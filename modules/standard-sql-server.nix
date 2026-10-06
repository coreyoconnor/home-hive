{
  config,
  pkgs,
  nixpkgs-unstable,
  lib,
  ...
}:
with lib; let
  nixpkgs-unstable-pkgs = config.nixpkgs-unstable.pkgs;
in {
  options.services.standard-sql-server = {
    enable = mkOption {
      default = config.services.house-manager.enable;
      example = true;
      type = with types; bool;
    };
  };

  config = mkIf config.services.standard-sql-server.enable {
    networking.firewall.allowedTCPPorts = [ 5432 ];
    services.postgresql = {
      authentication = ''
        host all all 192.168.88.0/24 trust
        host all all 10.42.0.0/24 trust
        host all all 168.254.0.0/16 trust
      '';
      dataDir = "/var/lib/postgresql/16";
      enable = true;
      enableTCPIP = true;
      # listenAddresses = "192.168.88.4";
      enableJIT = true;
      ensureDatabases = ["hass"];
      ensureUsers = [
        {
          name = "hass";
          ensureDBOwnership = true;
        }
      ];
      package = pkgs.postgresql_16;
    };

    systemd.services.postgresql.serviceConfig.TimeoutSec = lib.mkOverride 10 666;
  };
}
