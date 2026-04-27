self: super: {
  keyd = super.keyd.overrideAttrs (oldAttrs: {
    src = assert (self.lib.versionOlder oldAttrs.version "2.6.0");
      self.fetchFromGitHub {
        owner = "rvaiya";
        repo = "keyd";
        rev = "7c0aecb8bfd34dc8642bf4eefd2e59c89e61cec3";
        hash = "sha256-l7yjGpicX1ly4UwF7gcOTaaHPRnxVUMwZkH70NDLL5M=";
      };
  });
}
