{
  config,
  lib,
  pkgs,
  ...
}: {
  services.samba = {
    settings = {
      "user_coconnor" = {
        "path" = "/mnt/storage/users/coconnor";
        "valid users" = "coconnor";
        "public" = "no";
        "writeable" = "yes";
        "force user" = "coconnor";
        "fruit:aapl" = "yes";
        "vfs objects" = "catia fruit streams_xattr";
      };
    };
  };
}
