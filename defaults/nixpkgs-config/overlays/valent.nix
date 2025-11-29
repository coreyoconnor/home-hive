self: super: {
  valent = super.valent.overrideAttrs (oldAttrs: {
    src = self.fetchFromGitHub {
      repo = "valent";
      #owner = "coreyoconnor";
      # rev = "ef1945c69993e8614b1a8444461d72e13652aab6";
      # hash = "sha256-pgL8LzEp6+kKLDUPzkY1ehg+4N7zGSff7kThNcaCsw0=";
      owner = "andyholmes";
      rev = "76cbc439f011148d562d96737f8e66f2b74ec803";
      hash = "sha256-4Xxp1q2ALlaeS2j6riAqk+XFq+l806kj3oEedVBg0lU=";
      fetchSubmodules = true;
    };
  });
}
