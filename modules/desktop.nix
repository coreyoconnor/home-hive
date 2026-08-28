{
  config,
  pkgs,
  lib,
  sway-gnome,
  ...
}:
with lib; let
  cfg = config.desktop;
in {
  options = {
    desktop = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      rt = mkOption {
        type = types.bool;
        default = true;
      };
      use-unstable-mesa = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  imports = [
    ../hardware/desktop-devices.nix
    ./desktop
    sway-gnome.nixosModules.default
  ];

  config = mkIf cfg.enable {
    # waydroid
    networking.nftables.enable = true;

    semi-active-av.enable = true;

    boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_7_2.override {
      structuredExtraConfig = with lib.kernel; {
        PREEMPT_RT =
          if cfg.rt
          then yes
          else no;
        PREEMPT_COUNT = yes;
        CONFIG_MK8 = yes;
        CONFIG_GENERIC_CPU = unset;
        CONFIG_X86_INTEL_USERCOPY = yes;
        CONFIG_X86_USE_PPRO_CHECKSUM = yes;

        # wine gaming perf
        CONFIG_NTSYNC = yes;
      };
      ignoreConfigErrors = true;
    });

    environment.systemPackages = with pkgs; [
      # android-translation-layer
      appimage-run
      brave
      brightnessctl
      foot
      fuzzel # launcher
      evince
      gnome-terminal
      nautilus
      gnomeExtensions.appindicator
      grim # screjnshot functionality
      keybase-gui
      ispell
      mako # notification system developed by swaywm maintainer
      neovim-qt
      nordpass
      clinfo
      pavucontrol
      qt6Packages.qtwayland
      slurp # screenshot functionality
      awww # wallpaper
      vulkan-tools
      waybar
      wayland
      wine
      wine64Forwarder
      winetricks
      wlogout
      wluma # brightness control
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    ];

    hardware = {
      graphics = {
        enable = true;
      } // (mkIf cfg.use-unstable-mesa {
        package = config.nixpkgs-unstable.pkgs.mesa;
        package32 = config.nixpkgs-unstable.pkgs.pkgsi686Linux.mesa;
      });
    };

    programs = {
      firefox = {
        enable = true;
        package = config.nixpkgs-unstable.pkgs.firefox;
      };
    };

    sway-gnome = {
      enable = true;
      package = config.nixpkgs-unstable.pkgs.sway-unwrapped;
    };

    security.rtkit.enable = true;

    services = {
      automatic-timezoned.enable = true;

      dbus.enable = true;

      flatpak.enable = true;

      gnome = {
        core-developer-tools.enable = true;
        games.enable = true;
      };

      kubo = {
        enable = false;
      };

      libinput.enable = mkDefault true;

      packagekit.enable = false;

      pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
      };

      printing.enable = true;

      samba-wsdd.enable = true;

      sysprof.enable = true;

      xserver.enable = true; # for xwayland

      xfs.enable = false;

      udev.extraRules = ''
        KERNEL=="ntsync", MODE="0644"
      '';
    };

    systemd.user.extraConfig = ''
      DefaultEnvironment="PATH=/run/current-system/sw/bin" _winesync=true
    '';

    time.timeZone = null;

    xdg.mime.enable = true;

    xdg.portal = {
      enable = true;
    };

    users.groups.plugdev = { };
    users.groups.uinput = { };
  };
}
