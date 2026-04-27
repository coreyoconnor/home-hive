self: super: {
  libratbag = super.libratbag.overrideAttrs (oldAttrs: {
    src = self.fetchFromGitHub {
      owner = "libratbag";
      repo = "libratbag";
      rev = "874c01732a7d3c074baefd8055c0d3efe8c9a935";
      hash = "sha256-O9DxwAieUEy+otwDSM2412vCCQJkHIrDOPVYevg0l44=";
    };
  });
}
