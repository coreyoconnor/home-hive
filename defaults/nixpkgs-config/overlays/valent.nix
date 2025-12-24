self: super: {
  valent = super.valent.overrideAttrs (oldAttrs: {
    src = self.fetchFromGitHub {
      repo = "valent";
      #owner = "coreyoconnor";
      # rev = "ef1945c69993e8614b1a8444461d72e13652aab6";
      # hash = "sha256-pgL8LzEp6+kKLDUPzkY1ehg+4N7zGSff7kThNcaCsw0=";
      owner = "andyholmes";
      rev = "7231f2a68257eac6ed58aa67c8272c04cc4f03e0";
      hash = "sha256-dHVt5m5IA7nsmvqTQkk4YZJeGEHJDTeaqVBVZ85q2J0=";
      fetchSubmodules = true;
    };
  });
}
