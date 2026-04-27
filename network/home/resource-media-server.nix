{
  config,
  lib,
  pkgs,
  ...
}: {
  services.samba = {
    enable = true;
    package = pkgs.samba4Full;
    openFirewall = true;
    settings = {
      global = {
        "create mask" = "0664";
        "directory mask" = "0775";
        "server role" = "standalone";
        "guest account" = "media";
        "map to guest" = "bad user";
        "security" = "auto";
        "domain master" = "no";
        "local master" = "no";
        "preferred master" = "no";
        "interfaces" = "enp179s0";
      };
      media = {
        "path" = "/mnt/storage/media";
        "comment" = "Public media";
        "browseable" = "yes";
        "writeable" = "yes";
        "guest ok" = "yes";
        "guest only" = "yes";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  environment.etc = {
    "systemd/dnssd/smb.dnssd".source = pkgs.writeText "smb.dnssd" ''
      [Service]
      Name=%H
      Type=_smb._tcp
      Port=445
      TxtText=model=MacPro
    '';
  };
}
