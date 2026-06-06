# GitHub over SSH from the Terminal

Set up Git and an SSH key so you can push to GitHub without typing a password.

## 1. Set your Git identity

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

## 2. Install Git and OpenSSH

```bash
sudo pacman -S git openssh
```

## 3. Generate an SSH key

```bash
ssh-keygen -t ed25519 -C "you@example.com"
```

Press Enter to accept the default path (`~/.ssh/id_ed25519`).

## 4. Start the SSH agent and add the key

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

## 5. Add the public key to GitHub

Copy the contents of the public key:

```bash
cat ~/.ssh/id_ed25519.pub
```

Paste it into **GitHub → Settings → SSH and GPG keys → New SSH key**.

## 6. Test the connection

```bash
ssh -T git@github.com
```

You should see a "successfully authenticated" message.

## 7. (Optional) Always use SSH instead of HTTPS

Rewrites `https://github.com/` remotes to use SSH automatically:

```bash
git config --global url."git@github.com:".insteadOf https://github.com/
```
