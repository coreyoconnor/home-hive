{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = {
    powerManagement.cpuFreqGovernor = "powersave";
    powerManagement.powertop.enable = true;

    environment.systemPackages = [
      pkgs.cpupower-gui
      pkgs.powertop
    ];
  };
}
