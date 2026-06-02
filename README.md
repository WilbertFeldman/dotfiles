# Dotfiles

Personal macOS configuration managed with nix-darwin.

## Layout

- `flake.nix` defines the nix-darwin system.
- `modules/darwin.nix` contains general macOS, package, Homebrew, and shell settings.
- `modules/kmonad.nix` contains the KMonad overlay, `/etc/kmonad/config.kbd`, and launchd daemon.
- `kmonad/config.kbd` is the KMonad keyboard config.
- `nvim/` is the LazyVim starter config. nix-darwin links it to `~/.config/nvim` on activation.

`/etc/nix-darwin` is a symlink to this directory, so either of these commands targets the same flake:

```sh
sudo darwin-rebuild switch --flake /etc/nix-darwin#Wilberts-Laptop
sudo darwin-rebuild switch --flake ~/dotfiles#Wilberts-Laptop
```

On first activation, if `~/.config/nvim` already exists and is not a symlink, it is backed up to
`~/.config/nvim.bak-<timestamp>` before the LazyVim config is linked.
