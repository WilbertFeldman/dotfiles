{ lib, pkgs, ... }:

let
  enableKmonadDaemon = true;
in
{
  nixpkgs.overlays = [
    (final: prev: {
      haskellPackages = prev.haskellPackages.override {
        overrides = hfinal: hprev: {
          kmonad = prev.haskell.lib.disableCabalFlag
            (prev.haskell.lib.enableCabalFlag
              (prev.haskell.lib.overrideCabal hprev.kmonad (drv: {
                src = prev.fetchFromGitHub {
                  owner = "kmonad";
                  repo = "kmonad";
                  rev = "0.4.5";
                  fetchSubmodules = true;
                  hash = "sha256-hyCq5XgaYQrnyWB+kNe7ETsuakWYKJhPm2CbT96mJTw=";
                };
              }))
              "dext")
            "kext";
        };
      };

      kmonad = final.haskellPackages.kmonad;
    })
  ];

  environment.etc."kmonad/config.kbd".source = ../kmonad/config.kbd;

  launchd.daemons.kmonad = lib.mkIf enableKmonadDaemon {
    serviceConfig = {
      ProgramArguments = [
        "/run/current-system/sw/bin/kmonad"
        "/etc/kmonad/config.kbd"
      ];

      RunAtLoad = true;
      KeepAlive = false;

      StandardOutPath = "/var/log/kmonad.log";
      StandardErrorPath = "/var/log/kmonad.err.log";
    };
  };
}
