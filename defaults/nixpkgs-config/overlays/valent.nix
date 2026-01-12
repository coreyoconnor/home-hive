self: super: {
  valent = super.valent.overrideAttrs (oldAttrs: {
    src = self.fetchFromGitHub {
      repo = "valent";
      #owner = "coreyoconnor";
      # rev = "ef1945c69993e8614b1a8444461d72e13652aab6";
      # hash = "sha256-pgL8LzEp6+kKLDUPzkY1ehg+4N7zGSff7kThNcaCsw0=";
      owner = "andyholmes";
      rev = "d880881d6e78f8b19159effdd619d693467d0061";
      hash = "sha256-rmhSpUptLJfPSnDUUvf6eVMl+KVPOTOTpF4ySr57BHc=";
      fetchSubmodules = true;
    };
  });
}
