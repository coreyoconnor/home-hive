{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = {
    services.kmscon.extraConfig = ''
      no-switchvt
    '';
  };
}
