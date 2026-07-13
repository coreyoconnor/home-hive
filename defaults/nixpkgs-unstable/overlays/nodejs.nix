self: super: rec {
  nodejs-slim_24 = builtins.trace "unstable nodejs-slim_24" (super.nodejs-slim_24.overrideAttrs {
    doCheck = false;
    checkTarget = [];
    checkPhase = ''
      echo skip
    '';
  });

  nodejs_24 = super.nodejs_24.override {
    nodejs-slim = nodejs-slim_24;
  };

  nodejs = nodejs_24;
}
