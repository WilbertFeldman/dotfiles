{ pkgs, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.primaryUser = "wilbertfeldman";

  homebrew = {
    enable = true;

    casks = [
      "karabiner-elements"
    ];

    onActivation = {
      cleanup = "zap";
    };
  };

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    ripgrep
    fd
    jq
    eza
    bat
    zoxide
    direnv
    nix-direnv
    neovim
    ghostty-bin
    kmonad
  ];

  programs.zsh.enable = true;

  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";
    NSGlobalDomain.AppleShowAllExtensions = true;
    NSGlobalDomain.InitialKeyRepeat = 15;
    NSGlobalDomain.KeyRepeat = 2;
  };

  system.stateVersion = 6;
}
