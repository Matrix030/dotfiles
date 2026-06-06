# Wi-Fi with iwd / iwctl (Clean Arch Install)

Connect to Wi-Fi on a fresh Arch system using `iwd` and its client `iwctl`.

## 1. Install iwd

```bash
sudo pacman -S iwd
```

## 2. Enable and start the service

```bash
sudo systemctl enable iwd.service
sudo systemctl start iwd.service
```

Check its status:

```bash
systemctl status iwd.service
```

## 3. Connect with iwctl

Open the interactive client:

```bash
iwctl
```

Inside the prompt:

```bash
# List wireless devices (e.g. wlan0)
device list

# Scan and list networks
station wlan0 scan
station wlan0 get-networks

# Connect (you'll be prompted for the password)
station wlan0 connect "SSID"

# Leave the client
exit
```

## 4. Networking backend (choose one)

### Option 1 — NetworkManager with iwd as backend (recommended)

Best if you want GUI tools (`nm-applet`) or `nmcli`.

Edit `/etc/NetworkManager/NetworkManager.conf`:

```ini
[device]
wifi.backend=iwd
```

Restart NetworkManager:

```bash
sudo systemctl restart NetworkManager
```

NetworkManager now uses `iwd` instead of `wpa_supplicant` for Wi-Fi.

### Option 2 — iwd standalone (handles Wi-Fi + networking itself)

Edit (or create) `/etc/iwd/main.conf`:

```ini
[Network]
EnableIPv6=true
```

Restart iwd:

```bash
sudo systemctl restart iwd
```

## 5. Connected but no ping (DNS not working)

Let iwd configure the network and DNS itself. Edit `/etc/iwd/main.conf`:

```ini
[General]
EnableNetworkConfiguration=true

[Network]
NameResolvingService=systemd
```

Restart the services:

```bash
sudo systemctl restart iwd
sudo systemctl restart systemd-resolved
```

Reconnect:

```bash
iwctl
station wlan0 disconnect
station wlan0 connect "SSID"
```

Verify:

```bash
station wlan0 show
```
