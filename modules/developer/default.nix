{
  config,
  pkgs,
  lib,
  nixpkgs-unstable,
  ...
}:
with lib; let
  cfg = config.developer-base;
  nixpkgs-unstable-pkgs = nixpkgs-unstable.legacyPackages.${pkgs.system};
in {
  imports = [
    ./enable-profiling.nix
  ];

  config = mkIf cfg.enable {
    environment.shellInit = ''
      export JAVA_HOME=${pkgs.jdk}
    '';

    environment.systemPackages = with pkgs; [
      autoconf
      automake
      bash-language-server
      bloop
      clang
      cloudflared # for cloudflare tunnel ssh connections
      conmon
      coursier
      file
      git
      jdk
      keybase
      kubectl
      kubernetes-helm
      libsecret # for secret-tool
      lua-language-server
      lua
      luarocks
      sbt
      scala-cli
      tree-sitter
      zig
    ];

    nixpkgs.config = {
      android_sdk.accept_license = true;
    };

    programs.ssh = {
      extraConfig = ''
        ForwardAgent yes
      '';
    };

    security.pam.loginLimits = [
      {
        domain = "*";
        type = "soft";
        item = "nproc";
        value = "unlimited";
      }
      {
        domain = "*";
        type = "-";
        item = "nofile";
        value = "1048576";
      }
      {
        domain = "*";
        type = "hard";
        item = "memlock";
        value = "57628376064";
      }
    ];
  };
}
