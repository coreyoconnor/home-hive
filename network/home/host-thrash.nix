{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [./default.nix];

  config = {
    networking = {
      useDHCP = true;
      wireless = {
        enable = true;
        networks = {
          KittyMeowMeow = {
            pskRaw = "ext:psk_kittymeowmeow";
          };
        };

        secretsFile = "/etc/wpa_supplicant-secrets.conf";
      };
    };
  };
}
