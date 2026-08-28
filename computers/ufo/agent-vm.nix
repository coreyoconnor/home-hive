{
  config,
  lib,
  pkgs,
  nixpkgs,
  microvm,
  llm-agents,
  ...
}:
with lib; {
  imports = [
    microvm.nixosModules.host
  ];
  config = {
    microvm.vms = {
      primary-agent = {
        pkgs = import nixpkgs { system = "x86_64-linux"; };

        config = {
          system.stateVersion = "26.05";

          networking = {
            hostname = "primary-agent";
            useNetworkd = true;
          };

          microvm = {
            vcpu = 4;
            mem = 2048;

            shares = [
              {
                source = "/nix/store";
                mountPoint = "/nix/.ro-store";
                tag = "ro-store";
                proto = "virtiofs";
              }
              {
                source = "/home/coconnor/Documents/areas/agent-primary";
                mountPoint = "/nix/.ro-store";
                tag = "ro-store";
                proto = "virtiofs";
              }
            ];
          };
        };
      };
    };
  };
}

