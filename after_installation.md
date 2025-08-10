# install nvim
sudo pacman -S neovim

# clipboard
sudo pacman -S wl-clipboard 


# install zsh
sudo pacman -S zsh

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

## change shell if you accidentally pressed no which installation:
chsh -s $(which zsh)

uncomment the shell comment in the kitty.conf file here
# for bluetooth
sudo pacman -S blueman bluez bluez-utils

# yay
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# zen-browser
yay -S zen-browser-bin

# Volume Control
sudo pacman -S pavucontrol

# waybar
sudo pacman -S waybar

## this is a write command do not copy paste this
nvim ~/.config/hypr/hyprland.conf

### add this in the hyprland.conf file
exec-once = waybar

# make your config
mkdir -p ~/.config/waybar
cp /etc/xdg/waybar/config ~/.config/waybar/
cp /etc/xdg/waybar/style.css ~/.config/waybar/

# Edit these
nvim ~/.config/waybar/config.jsonc
nvim ~/.config/waybar/style.css

# USE ONLY ONCE
hyprctl dispatch exec waybar

# add fonts
sudo pacman -S ttf-cascadia-code-nerd
fc-list | grep -i caskaydia
fc-cache -fv


# make this system default:
sudo pacman -S fontconfig
mkdir -p ~/.config/fontconfig/conf.d
nvim ~/.config/fontconfig/conf.d/99-default-font.conf
## put this inside:
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


### refersh:
fc-cache -fv

# install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash


# github push from terminal
git config --global user.name "Your Name"
git config --global user.email "you@example.com"

sudo pacman -S git openssh
ssh-keygen -t ed25519 -C "you@example.com"

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

copy the text from the pub file and paste it in the github ssh page
ssh -T git@github.com
git config --global url."git@github.com:".insteadOf https://github.com/
