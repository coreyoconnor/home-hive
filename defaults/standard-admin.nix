{
  config,
  pkgs,
  lib,
  nixpkgs-unstable,
  ...
}:
with lib; let
  nvim-unstable = config.nixpkgs-unstable.pkgs.neovim;
in {
  config = {
    # task accounting
    boot.kernel.sysctl = {
      "task_delayacct" = 1;
    };

    environment.systemPackages = with pkgs; [
      acpi
      cryptsetup
      fd
      fzf
      htop
      jq
      libsixel
      lm_sensors
      nvim-unstable
      pciutils
      pcre
      ripgrep
      scrub
      tmux
      usbutils
      w3m
      wget
      xxd
    ];

    environment.variables.EDITOR = mkOverride 950 "${nvim-unstable}/bin/nvim";

    programs = {
      direnv.enable = true;
      fish.enable = true;
    };

    security = {
      sudo = {
        enable = true;
        wheelNeedsPassword = false;
        configFile = ''
          Defaults:root,%wheel env_keep+=LOCALE_ARCHIVE
          Defaults:root,%wheel env_keep+=TERMINFO_DIRS
        '';
      };

      forcePageTableIsolation = true;
      virtualisation.flushL1DataCache = "cond";
    };

    users.defaultUserShell = pkgs.fish;
  };
}
