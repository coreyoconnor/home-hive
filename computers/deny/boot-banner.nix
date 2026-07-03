{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  banner = pkgs.runCommand "gen-banner" {} ''
    mkdir $out
    ${pkgs.figlet}/bin/figlet -f doh DENY > $out/banner.txt
  '';
in {
  config = {
    boot = {
      initrd = {
        boot-banner = {
          enable = true;
          inherit banner;
        };
      };
    };
  };
}
