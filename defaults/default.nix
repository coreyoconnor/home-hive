{
  config,
  pkgs,
  lib,
  ...
}:
with lib; rec {
  imports = [
    ./default-services.nix
    ./nixpkgs-config.nix
    ./nixpkgs-unstable-config.nix
    ./fonts.nix
    ./network.nix
    ./standard-admin.nix
    ./standard-nix.nix
    ./standard-services.nix
    ./udev.nix
    ./mdns.nix
  ];

  options = {
    default.graphical = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = {
    console = {
      keyMap = "us";
    };

    environment = {
      pathsToLink = ["/share" "/etc/gconf"];

      shellInit = ''
        export LC_ALL=${config.i18n.defaultLocale}
      '';
    };

    hardware = {
      enableAllFirmware = lib.mkDefault true;
      enableRedistributableFirmware = lib.mkDefault true;
    };

    i18n.defaultLocale = "en_US.UTF-8";

    time.timeZone = lib.mkDefault "UTC";

    services.journald.console = "/dev/tty12";

    # https://github.com/NixOS/nixpkgs/issues/549440
    boot.kernelModules = [ "ext4" ];
  };
}
