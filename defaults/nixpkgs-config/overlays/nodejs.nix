self: super: {
  nodejs-slim_24 = super.nodejs-slim_24.overrideAttrs {
    doCheck = false;
    checkPhase = ''
      echo skip
    '';
  };

  nodejs_24 = super.nodejs_24.override {
    nodejs-slim = self.nodejs-slim_24;
  };
}
