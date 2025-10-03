# How to Enable Dark Mode for Nautilus on Arch Linux + Hyprland

## Prerequisites
Nautilus 49+ uses libadwaita, which requires proper portal configuration to read dark mode settings.

## Steps

### 1. Install required packages
```bash
sudo pacman -S gnome-themes-extra xdg-desktop-portal-gtk
```

### 2. Set dark mode preference
```bash
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
```

### 3. Create GTK config files
```bash
mkdir -p ~/.config/gtk-4.0
cat > ~/.config/gtk-4.0/settings.ini << 'EOF'
[Settings]
gtk-application-prefer-dark-theme=1
gtk-theme-name=Adwaita-dark
EOF
```

```bash
mkdir -p ~/.config/gtk-3.0
cat > ~/.config/gtk-3.0/settings.ini << 'EOF'
[Settings]
gtk-application-prefer-dark-theme=1
gtk-theme-name=Adwaita-dark
EOF
```

### 4. Configure desktop portals for Hyprland
```bash
mkdir -p ~/.config/xdg-desktop-portal
cat > ~/.config/xdg-desktop-portal/hyprland-portals.conf << 'EOF'
[preferred]
default=hyprland;gtk
org.freedesktop.impl.portal.Settings=darkman;
EOF
```

### 5. Restart portal services
```bash
killall xdg-desktop-portal xdg-desktop-portal-hyprland
```

### 6. Restart Nautilus
```bash
killall nautilus
nautilus
```

## Why This Works
- Nautilus 49+ uses **libadwaita**, which ignores traditional GTK theme settings
- Libadwaita reads `color-scheme` through the **desktop portal** system
- Hyprland needs proper portal configuration to pass these settings to applications
- The portal config ensures the settings backend is available to libadwaita apps
