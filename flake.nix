{
  description = "";

  inputs = {
    nixpkgs.url = "github:coreyoconnor/nixpkgs/main";
    nixpkgs-unstable.url = "github:coreyoconnor/nixpkgs/unstable";

    nix_configs = {
      # I use `dev` branch but you should use `main`
      url = "github:coreyoconnor/nix_configs/dev";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-unstable.follows = "nixpkgs-unstable";
      };
    };

    nixos-hardware.url = "github:coreyoconnor/nixos-hardware/main";

    retronix = {
      url = "github:coreyoconnor/retronix/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    sway-gnome = {
      url = "github:coreyoconnor/sway-gnome/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-unstable.follows = "nixpkgs-unstable";
      };
    };
    voxtype = {
      url = "github:peteonrails/voxtype/main";
    };

    cpu-microcodes = {
      url = "github:platomav/CPUMicrocodes/ec5200961ecdf78cf00e55d73902683e835edefd";
      flake = false;
    };
    ucodenix = {
      url = "github:e-tho/ucodenix";
      inputs.cpu-microcodes.follows = "cpu-microcodes";
    };

    # TODO: migrate from
    nix-kube-modules.url = "github:coreyoconnor/nix-kube-modules";
  };

  outputs = {
    self,
    nix_configs,
    ...
  } @ inputs:
    nix_configs.lib.mkFlake inputs {
      systems = {
        deny = {system = "x86_64-linux";};
        glowness = {system = "x86_64-linux";};
        retronix-vm = {system = "x86_64-linux";};
        thrash = {system = "x86_64-linux";};
        ufo = {system = "x86_64-linux";};
        # systems that are not in the `computers/<hostname>` structure:
        installer-x86-iso = {
          name = "installer-x86-iso";
          system = "x86_64-linux";
          configPath = "${self}/installer";
          imageBuild = true;
        };
        postpi-0 = {
          name = "postpi-0-image";
          system = "aarch64-linux";
          configPath = "${self}/computers/postpi-0.nix";
          imageBuild = true;
        };
      };

      devFlakes = {
        nixos-hardware = {
          url = "git@github.com:coreyoconnor/nixos-hardware";
          branch = "dev";
          prodUrl = "git@github.com:coreyoconnor/nixos-hardware";
          prodBranch = "main";
        };
        retronix = {
          url = "git@github.com:coreyoconnor/retronix";
          branch = "dev";
          prodUrl = "git@github.com:coreyoconnor/retronix";
          prodBranch = "main";
        };
        sway-gnome = {
          url = "git@github.com:coreyoconnor/sway-gnome";
          branch = "dev";
          prodUrl = "git@github.com:coreyoconnor/sway-gnome";
          prodBranch = "main";
        };
        nixpkgs = {
          url = "git@github.com:coreyoconnor/nixpkgs";
          branch = "dev";
          prodUrl = "git@github.com:coreyoconnor/nixpkgs";
          prodBranch = "main";
          upstreamUrl = "https://github.com/NixOS/nixpkgs.git";
          upstreamBranch = "nixos-26.05";
        };
      };
    };
}
