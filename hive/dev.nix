let
  nixpkgs = ./dev-dependencies/nixpkgs;
  nix_configs = ./dev-dependencies/nix_configs;
  nixos-hardware = ./dev-dependencies/nixos-hardware;
  retronix = ./dev-dependencies/retronix;
  sway-gnome = ./dev-dependencies/sway-gnome;
in import ./default.nix { inherit nixpkgs nix_configs nixos-hardware retronix sway-gnome };

