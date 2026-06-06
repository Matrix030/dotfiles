#!/bin/bash

# Arch Linux Installation Script for Hyprland Dotfiles
# This script installs and configures a complete Hyprland desktop environment.
# Assumes: Fresh Arch Linux base installation with an internet connection.
# Note: No NVIDIA GPU support included (see extras/CUDA.md for that).
#
# Design: this script is deliberately fault-tolerant. It does NOT use `set -e`,
# because a single failed package (bad mirror, AUR build error, renamed
# package) should not abort the whole install and leave you half-configured.
# Instead, failures are collected and reported in a summary at the end.

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Tracking arrays for the final summary
FAILED_PKGS=()
FAILED_STEPS=()

# Logging functions
log_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $1"; }

# Install official-repo packages resiliently.
# Tries the whole batch first (fast); if that fails, retries each package
# individually so one bad package doesn't block the rest.
pac_install() {
    if sudo pacman -S --needed --noconfirm "$@"; then
        return 0
    fi
    log_warning "Batch install failed; retrying packages individually..."
    for pkg in "$@"; do
        if ! sudo pacman -S --needed --noconfirm "$pkg"; then
            log_error "Failed to install (pacman): $pkg"
            FAILED_PKGS+=("$pkg")
        fi
    done
}

# Install AUR packages one at a time (AUR builds fail more often, and we never
# want one failed build to skip the others).
aur_install() {
    for pkg in "$@"; do
        if ! yay -S --needed --noconfirm "$pkg"; then
            log_error "Failed to install (AUR): $pkg"
            FAILED_PKGS+=("$pkg (AUR)")
        fi
    done
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
# Acquire sudo up front and keep it alive
# Long AUR builds can otherwise outlast the sudo timestamp and stall on a
# password prompt mid-build.
# ============================================================================
log_info "Requesting sudo access (kept alive for the duration of the install)..."
if ! sudo -v; then
    log_error "Could not obtain sudo. Aborting."
    exit 1
fi
# Refresh sudo timestamp in the background until this script exits.
( while true; do sudo -n true; sleep 60; kill -0 "$$" 2>/dev/null || exit; done ) 2>/dev/null &
SUDO_KEEPALIVE_PID=$!
trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null' EXIT

# ============================================================================
# STEP 1: System Update
# ============================================================================
log_info "Updating system packages..."
if sudo pacman -Syu --noconfirm; then
    log_success "System updated"
else
    log_error "System update failed. Check your mirrors/network before continuing."
    FAILED_STEPS+=("System update (pacman -Syu)")
fi

# ============================================================================
# STEP 2: Install Base Development Tools
# ============================================================================
log_info "Installing base development tools..."
pac_install \
    base-devel \
    git \
    curl \
    wget \
    openssh \
    man-db \
    man-pages \
    unzip \
    zip
log_success "Base development tools step complete"

# ============================================================================
# STEP 3: Install yay (AUR Helper)
# ============================================================================
if ! command -v yay &> /dev/null; then
    log_info "Installing yay AUR helper..."
    (
        cd /tmp || exit 1
        rm -rf /tmp/yay
        git clone https://aur.archlinux.org/yay.git && \
        cd yay && \
        makepkg -si --noconfirm
    )
    if command -v yay &> /dev/null; then
        log_success "yay installed"
    else
        log_error "yay failed to install. All AUR packages below will be skipped."
        FAILED_STEPS+=("yay AUR helper (AUR packages will be skipped)")
    fi
else
    log_success "yay already installed"
fi

# Helper so AUR steps are skipped gracefully if yay is missing
have_yay() { command -v yay &> /dev/null; }

# ============================================================================
# STEP 4: Install Hyprland and Wayland Components
# ============================================================================
log_info "Installing Hyprland and Wayland components..."
pac_install \
    hyprland \
    hyprpaper \
    hyprlock \
    xdg-desktop-portal-hyprland \
    qt5-wayland \
    qt6-wayland \
    polkit-kde-agent
log_success "Hyprland step complete"

# ============================================================================
# STEP 5: Install UI Components (waybar, rofi, wofi, swaync)
# ============================================================================
log_info "Installing UI components..."
pac_install \
    waybar \
    rofi \
    wofi

# SwayNC from AUR
if have_yay; then
    aur_install swaync
else
    log_warning "Skipping swaync (yay unavailable)"
    FAILED_PKGS+=("swaync (AUR, skipped)")
fi
log_success "UI components step complete"

# ============================================================================
# STEP 6: Install Terminal and Shell
# ============================================================================
log_info "Installing terminal and shell..."
pac_install zsh

if have_yay; then
    aur_install ghostty
else
    log_warning "Skipping ghostty (yay unavailable)"
    FAILED_PKGS+=("ghostty (AUR, skipped)")
fi
log_success "Terminal and shell step complete"

# ============================================================================
# STEP 7: Install Fonts
# ============================================================================
log_info "Installing fonts..."
pac_install \
    ttf-cascadia-code-nerd \
    ttf-jetbrains-mono-nerd \
    ttf-font-awesome \
    noto-fonts \
    noto-fonts-emoji
log_success "Fonts step complete"

# ============================================================================
# STEP 8: Install System Utilities
# ============================================================================
log_info "Installing system utilities..."
pac_install \
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

if have_yay; then
    aur_install auto-cpufreq hyprshot
else
    log_warning "Skipping auto-cpufreq, hyprshot (yay unavailable)"
    FAILED_PKGS+=("auto-cpufreq (AUR, skipped)" "hyprshot (AUR, skipped)")
fi
log_success "System utilities step complete"

# ============================================================================
# STEP 9: Install Applications
# ============================================================================
log_info "Installing applications..."
pac_install \
    libreoffice-fresh

if have_yay; then
    aur_install \
        google-chrome \
        zen-browser-bin \
        visual-studio-code-bin \
        obsidian
else
    log_warning "Skipping AUR applications (yay unavailable)"
    FAILED_PKGS+=("google-chrome (AUR, skipped)" "zen-browser-bin (AUR, skipped)" "visual-studio-code-bin (AUR, skipped)" "obsidian (AUR, skipped)")
fi
log_success "Applications step complete"

# ============================================================================
# STEP 10: Install Oh My Zsh and plugins
# ============================================================================
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log_info "Installing Oh My Zsh..."
    if RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; then
        log_success "Oh My Zsh installed"
    else
        log_error "Oh My Zsh install failed"
        FAILED_STEPS+=("Oh My Zsh")
    fi
else
    log_success "Oh My Zsh already installed"
fi

log_info "Installing zsh plugins..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ -d "$HOME/.oh-my-zsh" ]; then
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" \
            || { log_error "Failed to clone zsh-autosuggestions"; FAILED_STEPS+=("zsh-autosuggestions"); }
    fi
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" \
            || { log_error "Failed to clone zsh-syntax-highlighting"; FAILED_STEPS+=("zsh-syntax-highlighting"); }
    fi
    log_success "zsh plugins step complete"
else
    log_warning "Skipping zsh plugins (Oh My Zsh not installed)"
fi

# ============================================================================
# STEP 11: Install zoxide
# ============================================================================
log_info "Installing zoxide..."
pac_install zoxide
log_success "zoxide step complete"

# ============================================================================
# STEP 12: Install Node.js and npm (for Neovim LSP)
# ============================================================================
log_info "Installing Node.js..."
pac_install nodejs npm
log_success "Node.js step complete"

# ============================================================================
# STEP 13: Initialize the nvim submodule (if needed)
# The .config/nvim config is tracked as a git submodule. On a fresh clone
# without --recurse-submodules it is an EMPTY directory, so the config would
# never deploy. Initialize it here.
# ============================================================================
if [ -d "$DOTFILES_DIR/.git" ] || [ -f "$DOTFILES_DIR/.git" ]; then
    if [ -z "$(ls -A "$DOTFILES_DIR/.config/nvim" 2>/dev/null)" ]; then
        log_info "nvim submodule appears uninitialized; initializing..."
        if git -C "$DOTFILES_DIR" submodule update --init --recursive; then
            log_success "nvim submodule initialized"
        else
            log_warning "Could not initialize nvim submodule; Neovim config may be missing"
            FAILED_STEPS+=("nvim submodule init")
        fi
    fi
fi

# ============================================================================
# STEP 14: Deploy Configuration Files
# ============================================================================
log_info "Deploying configuration files..."
mkdir -p "$HOME/.config"

for config_dir in "$DOTFILES_DIR/.config"/*; do
    [ -d "$config_dir" ] || continue
    dir_name=$(basename "$config_dir")

    # Skip empty directories (e.g. an uninitialized submodule) so we don't
    # clobber a working config with nothing.
    if [ -z "$(ls -A "$config_dir" 2>/dev/null)" ]; then
        log_warning "Skipping empty config dir: $dir_name"
        continue
    fi

    log_info "Copying $dir_name configuration..."

    # Backup existing config if it exists
    if [ -e "$HOME/.config/$dir_name" ]; then
        backup_name="$HOME/.config/${dir_name}.backup.$(date +%Y%m%d_%H%M%S)"
        log_warning "Backing up existing $dir_name to $backup_name"
        mv "$HOME/.config/$dir_name" "$backup_name"
    fi

    if cp -r "$config_dir" "$HOME/.config/"; then
        log_success "$dir_name configuration deployed"
    else
        log_error "Failed to copy $dir_name configuration"
        FAILED_STEPS+=("deploy config: $dir_name")
    fi
done
log_success "Configuration deployment step complete"

# ============================================================================
# STEP 15: Install Rofi Themes
# ============================================================================
log_info "Installing rofi themes..."
mkdir -p "$HOME/.local/share/rofi/themes"

if [ ! -d "/tmp/rofi-themes-collection" ]; then
    git clone https://github.com/lr-tech/rofi-themes-collection.git /tmp/rofi-themes-collection \
        || log_warning "Could not clone rofi themes collection"
fi

if [ -f "/tmp/rofi-themes-collection/themes/rounded-nord-dark.rasi" ]; then
    cp "/tmp/rofi-themes-collection/themes/rounded-nord-dark.rasi" "$HOME/.local/share/rofi/themes/"
    log_success "rofi theme installed"
else
    log_warning "rounded-nord-dark.rasi not found; install it manually if your rofi config needs it"
fi

# ============================================================================
# STEP 16: Change Default Shell to zsh
# ============================================================================
if command -v zsh &> /dev/null; then
    if [ "$SHELL" != "$(command -v zsh)" ]; then
        log_info "Changing default shell to zsh..."
        if chsh -s "$(command -v zsh)"; then
            log_success "Default shell changed to zsh (takes effect on next login)"
        else
            log_warning "Could not change shell automatically; run: chsh -s \$(command -v zsh)"
            FAILED_STEPS+=("chsh to zsh")
        fi
    else
        log_success "zsh is already the default shell"
    fi
else
    log_warning "zsh not installed; skipping shell change"
fi

# ============================================================================
# STEP 17: Enable and Start Services
# ============================================================================
log_info "Enabling and starting services..."
enable_service() {
    local svc="$1"
    if sudo systemctl enable --now "$svc"; then
        log_success "Enabled $svc"
    else
        log_warning "Could not enable $svc (is the package installed?)"
        FAILED_STEPS+=("enable service: $svc")
    fi
}
enable_service NetworkManager.service
enable_service bluetooth.service
enable_service auto-cpufreq.service
log_success "Services step complete"

# ============================================================================
# STEP 18: Update font cache
# ============================================================================
log_info "Updating font cache..."
fc-cache -fv && log_success "Font cache updated"

# ============================================================================
# STEP 19: Set up GTK theme for Nautilus dark mode
# ============================================================================
log_info "Configuring GTK settings for dark mode..."
mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"

for ver in 3.0 4.0; do
    cat > "$HOME/.config/gtk-$ver/settings.ini" << 'EOF'
[Settings]
gtk-application-prefer-dark-theme=1
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Adwaita
gtk-font-name=Sans 10
EOF
done
log_success "GTK dark mode configured"

# ============================================================================
# STEP 20: Create zsh configuration
# ============================================================================
log_info "Creating .zshrc configuration..."

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
# STEP 21: Final Summary
# ============================================================================
echo ""
echo "============================================================================"
if [ ${#FAILED_PKGS[@]} -eq 0 ] && [ ${#FAILED_STEPS[@]} -eq 0 ]; then
    log_success "Installation completed successfully — no failures detected!"
else
    log_warning "Installation finished, but some items need attention:"
    if [ ${#FAILED_PKGS[@]} -gt 0 ]; then
        echo ""
        log_error "Packages that failed to install:"
        for p in "${FAILED_PKGS[@]}"; do echo "    - $p"; done
    fi
    if [ ${#FAILED_STEPS[@]} -gt 0 ]; then
        echo ""
        log_error "Steps that failed or were skipped:"
        for s in "${FAILED_STEPS[@]}"; do echo "    - $s"; done
    fi
    echo ""
    log_info "Re-run this script to retry — already-installed packages are skipped (--needed)."
fi
echo "============================================================================"
echo ""

log_info "Next steps:"
echo "  1. Reboot your system: sudo reboot"
echo "  2. After reboot, select Hyprland from your display manager"
echo "  3. Or start Hyprland manually with: Hyprland"
echo ""
log_info "Keyboard shortcuts (from hyprland config):"
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
echo "  - Wallpapers:        ~/.config/.wallpapers/"
echo "  - Wallpaper config:  ~/.config/hypr/hyprpaper.conf"
echo "  - Keybindings:       ~/.config/hypr/hyprland.conf"
echo "  - Waybar config:     ~/.config/waybar/config.jsonc"
echo ""
log_info "Optional setup guides in the extras/ directory:"
echo "  - Git/GitHub SSH setup:  extras/git_installation.md"
echo "  - PostgreSQL setup:      extras/postgres.md"
echo "  - Fonts / CJK / LaTeX:   'extras/Latex and Special fonts.md'"
echo "  - NVIDIA + CUDA:         extras/CUDA.md"
echo ""
log_warning "Note: your shell will change to zsh on next login."
echo ""

# Flag file to indicate the script ran to completion
touch "$DOTFILES_DIR/.install_complete"

exit 0
