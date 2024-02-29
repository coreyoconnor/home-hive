{
  description = "";

  inputs = {
    nixpkgs.url = "github:coreyoconnor/nixpkgs/integ";
    nix_configs.url = "github:coreyoconnor/nix_configs/dev";
    nixos-hardware.url = "github:coreyoconnor/nixos-hardware/dev";
    retronix.url = "github:coreyoconnor/retronix/dev";
    sway-gnome.url = "github:coreyoconnor/sway-gnome/dev";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
  };

  outputs = { self, nixpkgs, nix_configs, nixos-hardware, retronix, sway-gnome, devshell, flake-utils }:
    let hive = import ./hive/default.nix { inherit nixpkgs nix_configs nixos-hardware retronix sway-gnome; };
    in { colmena = hive; } // flake-utils.lib.eachDefaultSystem (system: {
      devShell =
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ devshell.overlays.default ];
          };
        in
        pkgs.devshell.mkShell {
          imports = [ (pkgs.devshell.importTOML ./devshell.toml) ];
        };
    });
}
