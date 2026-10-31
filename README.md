# Dotfiles

Personal macOS configuration managed with nix-darwin.

## Layout

- `flake.nix` defines the nix-darwin system.
- `modules/darwin.nix` contains general macOS, package, Homebrew, and shell settings.
- `modules/kmonad.nix` contains the KMonad overlay, `/etc/kmonad/config.kbd`, and launchd daemon.
- `modules/t3code.nix` pins the T3 Code 0.1.2 source build and its dependencies.
- `kmonad/config.kbd` is the KMonad keyboard config.
- `nvim/` is the LazyVim starter config. nix-darwin links it to `~/.config/nvim` on activation.
- `.claude/skills/` holds Matt Pocock's skill set (the 27 skills published in the
  `mattpocock-skills` plugin), vendored unmodified from
  [mattpocock/skills](https://github.com/mattpocock/skills) at `5beb35b`. They are project-scoped,
  so they load only in Claude Code sessions in this repo. License: `.claude/skills/LICENSE.mattpocock-skills` (MIT).

`/etc/nix-darwin` is a symlink to this directory, so either of these commands targets the same flake:

```sh
sudo darwin-rebuild switch --flake /etc/nix-darwin#Wilberts-Laptop
sudo darwin-rebuild switch --flake ~/dotfiles#Wilberts-Laptop
```

T3 Code is installed through Nix. Launch the desktop app with `t3code-desktop`,
or run `t3` for its local web interface. Its source version is pinned in
`modules/t3code.nix`; updating `flake.lock` alone does not change that version.

Claude Code's native CLI is installed through the nix-darwin Homebrew cask list.
Run `claude auth login` to sign in, then launch it with `claude` from a project directory.

On first activation, if `~/.config/nvim` already exists and is not a symlink, it is backed up to
`~/.config/nvim.bak-<timestamp>` before the LazyVim config is linked.
