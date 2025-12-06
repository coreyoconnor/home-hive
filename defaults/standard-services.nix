{
  options,
  pkgs,
  lib,
  ...
}:
with lib; {
  config = {
    boot.blacklistedKernelModules = ["snd_pcsp"];

    networking = {
      timeServers =
        options.networking.timeServers.default
        ++ [
          "0.us.pool.ntp.org"
          "1.us.pool.ntp.org"
          "2.us.pool.ntp.org"
          "3.us.pool.ntp.org"
        ];
    };

    security.apparmor.enable = true;
    programs.gnupg.agent.enable = true;
  };
}
