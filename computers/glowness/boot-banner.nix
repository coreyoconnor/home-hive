{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = {
    boot = {
      initrd = {
        preLVMCommands = let
          banner = pkgs.runCommand "gen-banner" {} ''
            mkdir $out
            ${pkgs.figlet}/bin/figlet -f broadway GLOW > $out/banner.txt
            ${pkgs.figlet}/bin/figlet -f cybermedium NESS >> $out/banner.txt
          '';
        in ''
          cat ${banner}/banner.txt
        '';
      };
    };
  };
}
