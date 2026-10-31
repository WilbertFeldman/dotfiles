{
  description = "Wilbert's dotfiles and nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = inputs@{
    nix-darwin,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    ...
  }: {
    darwinConfigurations."Wilberts-Laptop" = nix-darwin.lib.darwinSystem {
      modules = [
        ./modules/darwin.nix
        ./modules/kmonad.nix
        ./modules/t3code.nix

        nix-homebrew.darwinModules.nix-homebrew

        {
          nix-homebrew = {
            enable = true;

            # Apple Silicon: installs native ARM Homebrew and Intel/Rosetta Homebrew.
            enableRosetta = true;

            user = "wilbertfeldman";

            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };

            mutableTaps = false;
          };
        }

        ({ config, ... }: {
          homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
        })
      ];
    };
  };
}
