{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  config = {
    networking.nftables.enable = true;
  };
}
