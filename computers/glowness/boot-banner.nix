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
        systemd.services.banner = let
          banner = pkgs.runCommand "gen-banner" {} ''
            mkdir $out
            ${pkgs.figlet}/bin/figlet -f doh GLOW > $out/banner.txt
            ${pkgs.figlet}/bin/figlet -f broadway NESS >> $out/banner.txt
          '';
        in {
          wantedBy = [ "initrd.target" ];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = pkgs.writeShellScript "banner.sh" ''
              cat ${banner}/banner.txt
            '';
          };
        };
      };
    };
  };
}
