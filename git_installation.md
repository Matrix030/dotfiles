# github push from terminal
```
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```
```
sudo pacman -S git openssh
ssh-keygen -t ed25519 -C "you@example.com"
```
```
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```
copy the text from the pub file and paste it in the github ssh page
```
ssh -T git@github.com
git config --global url."git@github.com:".insteadOf https://github.com/
```

