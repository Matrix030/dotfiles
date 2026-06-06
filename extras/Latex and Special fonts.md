# Fallback Fonts (CJK, Emoji, Math, MS Fonts)

Keep your Nerd Font for coding, but install fallback fonts so non-Latin text, emoji, and math symbols render everywhere instead of showing as tofu (□).

## 1. Install Noto fallback fonts

```bash
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
```

Optional extras:

```bash
yay -S ttf-ms-fonts ttf-unifont
```

## 2. Rebuild the font cache

```bash
fc-cache -fv
```

## How fallback works

Apps (browsers, terminals) automatically pick a fallback font when the active font lacks a character:

- Code → your Nerd Font
- Chinese / Japanese / Korean → `Noto Sans CJK`
- Emoji → `Noto Color Emoji`
- Math symbols, arrows → `Noto Sans Extra`

## Verify CJK is installed

```bash
fc-list | grep "Noto Sans CJK"
```

If this returns nothing, the CJK fonts are missing — install `noto-fonts-cjk` (step 1) and rebuild the cache.

## Microsoft fonts (Calibri, etc.)

```bash
yay -S ttf-ms-fonts
yay -S ttf-vista-fonts
```

Then rebuild the cache:

```bash
fc-cache -fv
```
