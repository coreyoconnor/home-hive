{
  config,
  pkgs,
  ...
}:
with pkgs.lib; {

  users.users = {
    coconnor = {
      isNormalUser = true;
      createHome = false;
      uid = 1100;
      group = "users";
      extraGroups = [
        "audio"
        "dialout"
        "jupyter"
        "libvirtd"
        "monkey"
        "plugdev"
        "podman"
        "systemd-journal"
        "transmission"
        "tty"
        "vboxusers"
        "video"
        "wheel"
        "kdm"
        config.services.kubo.group
      ];
      home = "/home/coconnor";
      shell = pkgs.fish;
      openssh.authorizedKeys.keyFiles = [./ssh/coconnor.pub];
      subUidRanges = [
        {
          startUid = 2000000;
          count = 65536;
        }
      ];
      subGidRanges = [
        {
          startGid = 2000000;
          count = 65536;
        }
      ];
    };
  };
}
