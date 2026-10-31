{ ... }:

{
  nixpkgs.overlays = [
    (_final: prev:
      let
        # Keep the stable source release explicit while nixpkgs catches up.
        pnpm = prev.pnpm_12;
        unwrapped = (prev.t3code.unwrapped.override {
          nodejs = prev.nodejs_26;
          pnpm_11 = pnpm;
        }).overrideAttrs (finalAttrs: oldAttrs: {
          version = "0.1.2";

          # Preserve bundled native prebuilds and avoid stripping every JS file.
          dontStrip = true;

          src = prev.fetchFromGitHub {
            owner = "pingdotgg";
            repo = "t3code";
            tag = "v${finalAttrs.version}";
            hash = "sha256-C5l7541kanlsukhswrAEu8GFpr/YpWDnofJ5dlg7+LM=";
          };

          pnpmDeps = prev.fetchPnpmDeps {
            inherit pnpm;
            inherit (finalAttrs) pname version src pnpmWorkspaces;
            fetcherVersion = 4;
            hash = "sha256-0vWOG04OA0u2dOH10rszwDkhT0JwdY37oIpWorRpwkY=";
          };

          # Upstream ships these public identifiers for T3 Connect source builds.
          postPatch = oldAttrs.postPatch + ''
            cp .env.example .env
          '';

          installPhase = prev.lib.replaceStrings
            [ "T3 Code (Alpha)" ]
            [ "T3 Code (Beta)" ]
            oldAttrs.installPhase;
        });

        resourceMonitor = prev.t3code.resourceMonitor.override {
          t3code-unwrapped = unwrapped;
        };
      in
      {
        t3code = prev.t3code.override {
          t3code-unwrapped = unwrapped;
          t3code-resource-monitor = resourceMonitor;
        };
      })
  ];
}
