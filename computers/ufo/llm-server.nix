{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = {
    services.ollama = {
      enable = true;
      package = pkgs.ollama-cpu;
      openFirewall = true;
    };
  };
}

