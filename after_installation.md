#install nvim
sudo pacman -S neovim

#install zsh
sudo pacman -S zsh

#install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

##change shell if you accidentally pressed no which installation:
chsh -s $(which zsh)

uncomment the shell comment in the kitty.conf file here
#for bluetooth
sudo pacman -S blueman bluez bluez-utils

# yay
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

#zen-browser
yay -S zen-browser-bin

#Volume Control
sudo pacman -S pavucontrol

#waybar
sudo pacman -S waybar

##this is a write command do not copy paste this
nvim ~/.config/hypr/hyprland.conf

###add this in the hyprland.conf file
exec-once = waybar

# make your config
mkdir -p ~/.config/waybar
cp /etc/xdg/waybar/config ~/.config/waybar/
cp /etc/xdg/waybar/style.css ~/.config/waybar/

#Edit these
nvim ~/.config/waybar/config.jsonc
nvim ~/.config/waybar/style.css

# USE ONLY ONCE
hyprctl dispatch exec waybar

#add fonts
sudo pacman -S ttf-cascadia-code-nerd
fc-list | grep -i caskaydia
fc-cache -fv


#install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
