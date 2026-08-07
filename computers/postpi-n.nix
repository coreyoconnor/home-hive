{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./postpi
  ];

  config = {
    system.stateVersion = "26.05";
  };
}
