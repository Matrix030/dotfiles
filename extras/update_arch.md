## ✅ Arch Linux Update Guide

### 1. Sync and update official packages

```bash
sudo pacman -Syu
```

- Updates package database and upgrades all system packages.
    
- If you see `linux` or `systemd` updated → reboot after finishing.
    

---

### 2. Update AUR packages (since you use `yay`)

```bash
yay -Syu
```

- Updates both repo + AUR packages.
- Use this after pacman update to keep everything in sync.

---
### 3. Check Arch news before updating

Open [archlinux.org/news](https://archlinux.org/news/) to see if there are **manual steps** (e.g., big `openssl`, `glibc`, or `python` bumps).

- This is the #1 way to avoid breakage.

---

### 4. Clean up old/orphaned packages

```bash
sudo pacman -Qtdq | sudo pacman -Rns -
```

- Removes unused dependencies to keep system tidy.

---

### 5. (Optional but safe) — Take a snapshot before updating

If you use **Btrfs** or want rollback:

- Install Timeshift:
    
    ```bash
    yay -S timeshift
    ```
    
- Create a snapshot before updating.
    

---

## 🔄 How often?

- Update **at least once a week** (daily is fine too).
    
- Don’t wait months — large jumps are more risky.
    

---

## 🛡 Summary

1. Check [Arch news](https://archlinux.org/news/)
    
2. `sudo pacman -Syu`
    
3. `yay -Syu`
    
4. Reboot if kernel/systemd updated
    
5. Clean or snapshot (optional)
    

