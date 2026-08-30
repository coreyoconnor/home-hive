{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = {
    services.ollama = {
      enable = false;
      package = pkgs.ollama-cpu;
      openFirewall = true;
      host = "192.168.88.4";
      port = 11434;
    };
  };
}

