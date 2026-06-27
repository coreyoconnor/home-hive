self: super: {
  libratbag = super.libratbag.overrideAttrs (oldAttrs: {
    src = self.fetchFromGitHub {
      owner = "libratbag";
      repo = "libratbag";
      rev = "2fb9a701e8c02bbe261eb141ff311a379837c63d";
      hash = "sha256-c4nAVhI3m9VeGy+rZLPS8Z98RS9JbrHe/mdiuee5y4s=";
    };
  });
}
