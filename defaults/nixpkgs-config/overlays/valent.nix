self: super: {
  valent = super.valent.overrideAttrs (oldAttrs: {
    src = self.fetchFromGitHub {
      repo = "valent";
      #owner = "coreyoconnor";
      # rev = "ef1945c69993e8614b1a8444461d72e13652aab6";
      # hash = "sha256-pgL8LzEp6+kKLDUPzkY1ehg+4N7zGSff7kThNcaCsw0=";
      owner = "andyholmes";
      rev = "df82168bc37ad1ec700c66b0f0f5dfd7a07be485";
      hash = "sha256-bg5p7Juw+O2vrfi2uDA69NPy68Zu8ig4ycVjhGkQ4ps=";
      fetchSubmodules = true;
    };

    buildInputs = oldAttrs.buildInputs ++ [ self.libdex ];
  });
}
