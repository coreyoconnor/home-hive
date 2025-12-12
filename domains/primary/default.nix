{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ./users
  ];
  config = {
    users.groups.plugdev = {};
  };
}
