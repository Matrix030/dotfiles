# yay
```
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

# man pages
```
sudo pacman -S man-db man-pages less
```

# zen-browser
```
yay -S zen-browser-bin
```

# ghostty
```
yay -S ghostty
```

# install nvm (required for nvim lsp)
```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
nvm install node
```

# install nvim
```
sudo pacman -S neovim
```
# clipboard
```
sudo pacman -S wl-clipboard 
```

# unzip - required for nvim
```
sudo pacman -S unzip
```

# Install rofi (follow this [guide](https://github.com/newmanls/rofi-themes-collection/tree/master)):
```
sudo pacman -S rofi
```

# install zsh
```
sudo pacman -S zsh
sudo pacman -Syu
```
# install oh-my-zsh
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## change shell if you accidentally pressed no which installation:
```
chsh -s $(which zsh)
```

# install fzf
```
yay -S fzf
```
## setup fzf keybindings and fuzzy completions for zsh in .zshrc
```
source <(zf --zsh)
```
## install bat (for fzf)
```
sudo pacman -S bat
```

### bat preview of fzf and jump to nvim shortcut (add in .zshrc)
```
alias inv='nvim $(fzf -m --preview="bat --color=always {}")'
```
### uncomment the shell comment in the kitty.conf file after completing the above steps

# Bluetooth Utils Installation
```
sudo pacman -S blueman bluez bluez-utils
```

# Volume Control
```
sudo pacman -S pavucontrol
```

# waybar
```
sudo pacman -S waybar
```

## this is a write command do not copy paste this
```
nvim ~/.config/hypr/hyprland.conf
```

### add this in the hyprland.conf file
```
exec-once = waybar
```

# make your config for waybar 
```
mkdir -p ~/.config/waybar
cp /etc/xdg/waybar/config ~/.config/waybar/
cp /etc/xdg/waybar/style.css ~/.config/waybar/
```

# Edit these for git clone from this repo
```
nvim ~/.config/waybar/config.jsonc
nvim ~/.config/waybar/style.css
```

# USE ONLY ONCE FOR THE FIRST RUN (RECOMMENDED TO JUST LOGOUT AND LOGIN)
```
hyprctl dispatch exec waybar
```

# add fonts
```
sudo pacman -S ttf-cascadia-code-nerd
fc-list | grep -i caskaydia
fc-cache -fv
```

# make this system default:
```
sudo pacman -S fontconfig
mkdir -p ~/.config/fontconfig/conf.d
nvim ~/.config/fontconfig/conf.d/99-default-font.conf
```

## put this inside:
```
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <!-- Default font for sans-serif -->
  <match target="pattern">
    <test name="family"><string>sans-serif</string></test>
    <edit name="family" mode="assign" binding="strong">
      <string>CaskaydiaCove Nerd Font Mono</string>
    </edit>
  </match>

  <!-- Default font for serif -->
  <match target="pattern">
    <test name="family"><string>serif</string></test>
    <edit name="family" mode="assign" binding="strong">
      <string>CaskaydiaCove Nerd Font Mono</string>
    </edit>
  </match>

  <!-- Default font for monospace -->
  <match target="pattern">
    <test name="family"><string>monospace</string></test>
    <edit name="family" mode="assign" binding="strong">
      <string>CaskaydiaCove Nerd Font Mono</string>
    </edit>
  </match>
</fontconfig>
```

### refersh:
```
fc-cache -fv
```

# install hyprpaper:
```
yay -S hyprpaper
```

# install obsidian
```
yay -S obsidian
```

# vscode installation (incase you break the shell config file):
```
yay -S visual-studio-code-bin
```

# rsync
```
sudo pacman -S rsync
```

# lsd
```
sudo pacman -S lsd
```

# power-management (cpu-power)
```
yay -S auto-cpufreq
sudo systemctl enable --now auto-cpufreq
auto-cpufreq --monitor  # works on desktops only for some reason
```

# zoxide
```
sudo pacman -S zoxide
```

# swaync
```
yay -S swaync
```

## After installation 
```
mkdir -p ~/.config/swaync
```

## Start swaync with Hyprland
```
nvim ~/.config/hypr/hyprland.conf
```
```
exec-once = swaync
```

# Chrome
```
yay -S google-chrome
```

# ripgrep
```
sudo pacman -S ripgrep
```

# libreOffice
```
sudo pacman -S libreoffice-fresh
```

# gammastep (bluelight Filter)
```
sudo pacman -S gammastep

gammastep -O 3500 //warm
gammastep -x      //Back to Normal
```
