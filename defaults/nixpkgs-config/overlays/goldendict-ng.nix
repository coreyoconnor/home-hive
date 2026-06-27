self: super: {
  goldendict-ng = super.goldendict-ng.overrideAttrs (oldAttrs: {
    # qtWrapperArgs = oldAttrs.qtWrapperArgs ++ [ "--set " ];
    src = self.fetchFromGitHub {
      owner = "xiaoyifang";
      repo = "goldendict-ng";
      rev = "63c5ceb047f900de350ebab2abfc50bbc83de7c0";
      hash = "sha256-2IBcNK1R5WCSql4xsh8+v+A9J1xvBTpb2NFMTEqH+vY=";
    };
  });
}
