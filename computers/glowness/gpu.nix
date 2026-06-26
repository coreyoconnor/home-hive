{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
  ];

  # AMD Radeon RX 6900 XT
  config = {
    boot = {
      # kernelParams = ["amdgpu.mcbp=0" "amd_iommu=off"];
      kernelParams = ["amd_iommu=off"];
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        libva-vdpau-driver
        libvdpau-va-gl
        rocmPackages.clr.icd
      ];
    };

    nixpkgs.config.rocmSupport = true;

    hardware.amdgpu = {
      opencl.enable = true;
      initrd.enable = true;
    };

    systemd.tmpfiles.rules =
      let
        rocmEnv = pkgs.symlinkJoin {
          name = "rocm-combined";
          paths = with pkgs.rocmPackages; [
            rocblas
            hipblas
            clr
          ];
        };
      in
      [
        "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
      ];

    programs.gamemode = {
      enable = true;
      settings.general.inhibit_screensaver = 0;
      enableRenice = true;
    };

    environment.systemPackages = with pkgs; [
      nvtopPackages.amd
    ];
  };
}
