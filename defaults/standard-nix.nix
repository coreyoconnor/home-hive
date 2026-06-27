{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
with lib; {
  config = {
    nix = {
      settings = {
        substituters = ["http://ufo:4999"];

        download-buffer-size = 300111222;

        trusted-public-keys = [
          "agh-1:qqgKseTFXMiOYrm+5LyWz/bKCXahP5KjW1RU6Fph674="
          "grr-1:YxoRaiS/IfOtt/DaNvU8xJ0BXxYI8poimtPhlWIWBAU="
          "ufo-1:xVu3KxBuyYSZnnqqZjDNFok7KQJtiDJHeshM84OJjXY="
        ];
      };
    };
  };
}
