#!/bin/bash

# Arch Linux Installation Script for Hyprland Dotfiles
# This script installs and configures a complete Hyprland desktop environment
# Assumes: Fresh Arch Linux base installation with internet connection
# Author: Generated for dotfiles repository
# Note: No NVIDIA GPU support included

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if script is run as root
if [ "$EUID" -eq 0 ]; then
    log_error "Please do not run this script as root"
    exit 1
fi

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
log_info "Dotfiles directory: $DOTFILES_DIR"

# Confirm before proceeding
echo ""
log_warning "This script will install a complete Hyprland desktop environment."
log_warning "It will modify system packages and configurations."
echo ""
read -p "Do you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log_info "Installation cancelled."
    exit 0
fi

# ============================================================================
# STEP 1: System Update
# ============================================================================
log_info "Updating system packages..."
sudo pacman -Syu --noconfirm
log_success "System updated"

# ============================================================================
# STEP 2: Install Base Development Tools
# ============================================================================
log_info "Installing base development tools..."
sudo pacman -S --needed --noconfirm \
    base-devel \
    git \
    curl \
    wget \
    openssh \
    man-db \
    man-pages \
    unzip \
    zip
log_success "Base development tools installed"

# ============================================================================
# STEP 3: Install yay (AUR Helper)
# ============================================================================
if ! command -v yay &> /dev/null; then
    log_info "Installing yay AUR helper..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd "$DOTFILES_DIR"
    log_success "yay installed"
else
    log_success "yay already installed"
fi

# ============================================================================
# STEP 4: Install Hyprland and Wayland Components
# ============================================================================
log_info "Installing Hyprland and Wayland components..."
sudo pacman -S --needed --noconfirm \
    hyprland \
    hyprpaper \
    hyprlock \
    xdg-desktop-portal-hyprland \
    qt5-wayland \
    qt6-wayland \
    polkit-kde-agent
log_success "Hyprland installed"

# ============================================================================
# STEP 5: Install UI Components
# ============================================================================
log_info "Installing UI components (waybar, rofi, wofi, swaync)..."

# Official repo packages
sudo pacman -S --needed --noconfirm \
    waybar \
    rofi \
    wofi

# SwayNC from AUR
yay -S --needed --noconfirm swaync

log_success "UI components installed"

# ============================================================================
# STEP 6: Install Terminal and Shell
# ============================================================================
log_info "Installing terminal and shell..."

# Install zsh
sudo pacman -S --needed --noconfirm zsh

# Install ghostty from AUR
yay -S --needed --noconfirm ghostty

log_success "Terminal and shell installed"

# ============================================================================
# STEP 7: Install Fonts
# ============================================================================
log_info "Installing fonts..."
sudo pacman -S --needed --noconfirm \
    ttf-cascadia-code-nerd \
    ttf-jetbrains-mono-nerd \
    ttf-font-awesome \
    noto-fonts \
    noto-fonts-emoji
log_success "Fonts installed"

# ============================================================================
# STEP 8: Install System Utilities
# ============================================================================
log_info "Installing system utilities..."

# Official repo utilities
sudo pacman -S --needed --noconfirm \
    ripgrep \
    fzf \
    bat \
    lsd \
    btop \
    neovim \
    brightnessctl \
    pavucontrol \
    pulseaudio \
    pulseaudio-bluetooth \
    bluez \
    bluez-utils \
    blueman \
    nautilus \
    grim \
    slurp \
    wl-clipboard \
    cliphist \
    jq \
    imagemagick \
    socat \
    networkmanager \
    network-manager-applet

# AUR utilities
yay -S --needed --noconfirm \
    auto-cpufreq \
    hyprshot

log_success "System utilities installed"

# ============================================================================
# STEP 9: Install Applications
# ============================================================================
log_info "Installing applications..."

# Official repo applications
sudo pacman -S --needed --noconfirm \
    google-chrome \
    libreoffice-fresh

# AUR applications
yay -S --needed --noconfirm \
    zen-browser-bin \
    visual-studio-code-bin \
    obsidian

log_success "Applications installed"

# ============================================================================
# STEP 10: Install Oh My Zsh
# ============================================================================
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log_info "Installing Oh My Zsh..."
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    log_success "Oh My Zsh installed"
else
    log_success "Oh My Zsh already installed"
fi

# Install zsh plugins
log_info "Installing zsh plugins..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

log_success "zsh plugins installed"

# ============================================================================
# STEP 11: Install zoxide
# ============================================================================
log_info "Installing zoxide..."
sudo pacman -S --needed --noconfirm zoxide
log_success "zoxide installed"

# ============================================================================
# STEP 12: Install Node.js and npm (for Neovim LSP)
# ============================================================================
log_info "Installing Node.js..."
sudo pacman -S --needed --noconfirm nodejs npm
log_success "Node.js installed"

# ============================================================================
# STEP 13: Deploy Configuration Files
# ============================================================================
log_info "Deploying configuration files..."

# Create .config directory if it doesn't exist
mkdir -p "$HOME/.config"

# Copy all configuration directories
for config_dir in "$DOTFILES_DIR/.config"/*; do
    if [ -d "$config_dir" ]; then
        dir_name=$(basename "$config_dir")
        log_info "Copying $dir_name configuration..."

        # Backup existing config if it exists
        if [ -e "$HOME/.config/$dir_name" ]; then
            backup_name="$HOME/.config/${dir_name}.backup.$(date +%Y%m%d_%H%M%S)"
            log_warning "Backing up existing $dir_name to $backup_name"
            mv "$HOME/.config/$dir_name" "$backup_name"
        fi

        cp -r "$config_dir" "$HOME/.config/"
        log_success "$dir_name configuration deployed"
    fi
done

# Copy rofi and wofi configs from root directory if they exist
if [ -d "$DOTFILES_DIR/rofi" ]; then
    log_info "Found additional rofi config in root directory"
    cp -r "$DOTFILES_DIR/rofi/"* "$HOME/.config/rofi/" 2>/dev/null || true
fi

if [ -d "$DOTFILES_DIR/wofi" ]; then
    log_info "Found additional wofi config in root directory"
    cp -r "$DOTFILES_DIR/wofi/"* "$HOME/.config/wofi/" 2>/dev/null || true
fi

log_success "Configuration files deployed"

# ============================================================================
# STEP 14: Install Rofi Themes
# ============================================================================
log_info "Installing rofi themes..."
mkdir -p "$HOME/.local/share/rofi/themes"

# Clone rofi themes repository if needed
if [ ! -d "/tmp/rofi-themes-collection" ]; then
    git clone https://github.com/lr-tech/rofi-themes-collection.git /tmp/rofi-themes-collection
fi

# Copy the rounded-nord-dark theme
if [ -f "/tmp/rofi-themes-collection/themes/rounded-nord-dark.rasi" ]; then
    cp "/tmp/rofi-themes-collection/themes/rounded-nord-dark.rasi" "$HOME/.local/share/rofi/themes/"
    log_success "rofi theme installed"
else
    log_warning "rounded-nord-dark.rasi theme not found, you may need to install it manually"
fi

# ============================================================================
# STEP 15: Change Default Shell to zsh
# ============================================================================
if [ "$SHELL" != "$(which zsh)" ]; then
    log_info "Changing default shell to zsh..."
    chsh -s "$(which zsh)"
    log_success "Default shell changed to zsh (will take effect on next login)"
else
    log_success "zsh is already the default shell"
fi

# ============================================================================
# STEP 16: Enable and Start Services
# ============================================================================
log_info "Enabling and starting services..."

# NetworkManager
sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service

# Bluetooth
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service

# Auto-cpufreq
sudo systemctl enable auto-cpufreq.service
sudo systemctl start auto-cpufreq.service

log_success "Services enabled and started"

# ============================================================================
# STEP 17: Configure fontconfig
# ============================================================================
log_info "Configuring fonts..."
sudo fc-cache -fv
log_success "Font cache updated"

# ============================================================================
# STEP 18: Set up GTK theme for Nautilus dark mode
# ============================================================================
log_info "Configuring GTK settings for dark mode..."
mkdir -p "$HOME/.config/gtk-3.0"
mkdir -p "$HOME/.config/gtk-4.0"

# GTK 3 settings
cat > "$HOME/.config/gtk-3.0/settings.ini" << 'EOF'
[Settings]
gtk-application-prefer-dark-theme=1
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Adwaita
gtk-font-name=Sans 10
EOF

# GTK 4 settings
cat > "$HOME/.config/gtk-4.0/settings.ini" << 'EOF'
[Settings]
gtk-application-prefer-dark-theme=1
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Adwaita
gtk-font-name=Sans 10
EOF

log_success "GTK dark mode configured"

# ============================================================================
# STEP 19: Create zsh configuration
# ============================================================================
log_info "Creating .zshrc configuration..."

# Backup existing .zshrc if it exists
if [ -f "$HOME/.zshrc" ]; then
    backup_name="$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
    log_warning "Backing up existing .zshrc to $backup_name"
    mv "$HOME/.zshrc" "$backup_name"
fi

cat > "$HOME/.zshrc" << 'EOF'
# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    fzf
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Aliases
alias ls='lsd'
alias ll='lsd -la'
alias cat='bat'
alias vim='nvim'
alias vi='nvim'

# Environment variables
export EDITOR='nvim'
export VISUAL='nvim'

# Initialize zoxide
eval "$(zoxide init zsh)"

# fzf configuration
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"
EOF

log_success ".zshrc created"

# ============================================================================
# STEP 20: Final Steps and Information
# ============================================================================
echo ""
echo "============================================================================"
log_success "Installation completed successfully!"
echo "============================================================================"
echo ""
log_info "Next steps:"
echo "  1. Reboot your system: sudo reboot"
echo "  2. After reboot, select Hyprland from your display manager"
echo "  3. Or start Hyprland manually with: Hyprland"
echo ""
log_info "Keyboard shortcuts (from hyprland.conf):"
echo "  SUPER + Q         - Launch Ghostty terminal"
echo "  SUPER + C         - Close window"
echo "  SUPER + M         - Exit Hyprland"
echo "  SUPER + E         - Open Nautilus file manager"
echo "  SUPER + V         - Toggle floating"
echo "  SUPER + R         - Launch Rofi"
echo "  SUPER + P         - Pseudo tiling"
echo "  SUPER + J         - Toggle split"
echo "  SUPER + L         - Lock screen (Hyprlock)"
echo "  SUPER + SHIFT + S - Screenshot"
echo "  SUPER + B         - Toggle Waybar"
echo ""
log_info "Additional configurations:"
echo "  - Wallpapers are in: ~/.config/.wallpapers/"
echo "  - Edit wallpaper: ~/.config/hypr/hyprpaper.conf"
echo "  - Edit keybindings: ~/.config/hypr/hyprland.conf"
echo "  - Waybar config: ~/.config/waybar/config.jsonc"
echo ""
log_info "Optional: Check extras/ directory for additional setup guides:"
echo "  - Git/GitHub SSH setup: extras/git_installation.md"
echo "  - PostgreSQL setup: extras/postgres.md"
echo "  - LaTeX setup: extras/Latex and Special fonts.md"
echo ""
log_warning "Note: Your shell will change to zsh on next login"
echo ""

# Create a flag file to indicate installation is complete
touch "$DOTFILES_DIR/.install_complete"

exit 0
