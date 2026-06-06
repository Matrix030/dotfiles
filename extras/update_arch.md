# Arch Linux Update Guide

## 1. Check Arch news first

Open [archlinux.org/news](https://archlinux.org/news/) before updating to see if there are **manual intervention** steps (e.g. big `openssl`, `glibc`, or `python` bumps). This is the number one way to avoid breakage.

## 2. Sync and update official packages

```bash
sudo pacman -Syu
```

Updates the package database and upgrades all system packages. If `linux` or `systemd` are updated, reboot after finishing.

## 3. Update AUR packages

Since you use `yay`:

```bash
yay -Syu
```

This updates both repo and AUR packages, keeping everything in sync.

## 4. Clean up orphaned packages

```bash
sudo pacman -Qtdq | sudo pacman -Rns -
```

Removes unused dependencies. If there are no orphans, pacman simply reports nothing to do.

## 5. (Optional) Snapshot before updating

If you use Btrfs or want rollback capability:

```bash
yay -S timeshift
```

Then create a snapshot before each update.

## How often?

- Update at least once a week (daily is fine).
- Don't wait months — large jumps are riskier.

## Summary

1. Check [Arch news](https://archlinux.org/news/)
2. `sudo pacman -Syu`
3. `yay -Syu`
4. Reboot if the kernel or systemd was updated
5. Clean orphans or snapshot (optional)
