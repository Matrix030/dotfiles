# Dotfiles repo — agent notes

This repo (`Matrix030/dotfiles`, remote `origin`, branch `main`) stores the user's
dotfiles. The user's **live** config lives in `~/.config` and is the source of truth /
"most updated" version. This repo's `.config/` is a curated subset that gets pushed to
GitHub.

## The recurring task: "sync my configs and push"

When the user asks to copy/update configs from their machine into this repo:

1. **Source** = `~/.config` (live, most updated).
   **Destination** = `~/dev/.dotfiles/.config` (this repo).
2. **Only sync items that already exist in the destination.** Do NOT copy every dir from
   `~/.config` — only the ones already tracked here. Mirror each with:
   ```
   rsync -a --delete ~/.config/<name>/ ~/dev/.dotfiles/.config/<name>/
   ```
3. Some dirs may exist in the destination but NOT in source (e.g. `fontconfig`,
   `.wallpapers`) — leave those untouched.
4. After syncing, `git add -A`, commit, push to `main`.

## Important: `.config/nvim` is a git submodule

- It's a gitlink (mode 160000) — its own repo: `Matrix030/kickstart.nvim`, branch `master`.
- Syncing it may leave it "-dirty" or move its pointer. To push properly:
  1. `cd .config/nvim`, `git add -A && git commit && git push origin master`
  2. If push is rejected (remote diverged), `git fetch` then `git rebase origin/master`
     (local changes have rebased cleanly so far — usually touches `init.lua` server/parser
     lists), then push.
  3. Back in repo root, `git add .config/nvim` to record the new submodule commit, then
     commit + push the superproject.

## Dirs currently tracked in `.config/`

`.wallpapers` (dest-only), `fontconfig` (dest-only), `ghostty`, `hypr`, `i3`, `kitty`,
`nautilus`, `nvim` (submodule), `pypr`, `rofi`, `swaync`, `waybar`, `wofi`.

## pypr / pyprland

`.config/pypr/config.toml` is tracked and **important** — always include it in syncs.
AUR package: `pyprland` (binary `pypr`, from hyprland-community/pyprland).

## Misc

- Do not co-author commits (per user's global preference).
