{ pkgs, ... }:

let
  user = "wilbertfeldman";
  dotfilesDir = "/Users/${user}/dotfiles";
in
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.primaryUser = user;

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
    t3code
    direnv
    nix-direnv
    neovim
    lazygit
    tree-sitter
    ghostty-bin
    kmonad
  ];

  system.activationScripts.extraActivation.text = ''
    nvim_source="${dotfilesDir}/nvim"
    nvim_config="/Users/${user}/.config/nvim"

    if [ ! -d "$nvim_source" ]; then
      echo "warning: LazyVim config source not found at $nvim_source"
    else
      /usr/bin/install -d -o ${user} -g staff "/Users/${user}/.config"

      if [ -L "$nvim_config" ]; then
        current_target="$(/usr/bin/readlink "$nvim_config")"
        if [ "$current_target" != "$nvim_source" ]; then
          /bin/ln -sfn "$nvim_source" "$nvim_config"
          /usr/sbin/chown -h ${user}:staff "$nvim_config"
        fi
      elif [ -e "$nvim_config" ]; then
        backup_path="$nvim_config.bak-$(/bin/date +%Y%m%d%H%M%S)"
        /bin/mv "$nvim_config" "$backup_path"
        /bin/ln -s "$nvim_source" "$nvim_config"
        /usr/sbin/chown -h ${user}:staff "$nvim_config"
        echo "Backed up existing Neovim config to $backup_path"
      else
        /bin/ln -s "$nvim_source" "$nvim_config"
        /usr/sbin/chown -h ${user}:staff "$nvim_config"
      fi
    fi
  '';

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
