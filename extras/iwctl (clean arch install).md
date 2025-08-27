### 1. Install iwd

```bash
sudo pacman -S iwd
```

### 2. Enable and start the service

Enable it so it starts at boot:

```bash
sudo systemctl enable iwd.service
```

Start it immediately:

```bash
sudo systemctl start iwd.service
```

Check its status:

```bash
systemctl status iwd.service
```

### 3. Using `iwctl` (iwd client)

Run the interactive client:

```bash
iwctl
```

Inside the prompt you can:

- **List devices:**
    
    ```bash
    device list
    ```
    
- **Scan for networks:**
    
    ```bash
    station wlan0 scan
    station wlan0 get-networks
    ```
    
- **Connect to a network:**
    
    ```bash
    station wlan0 connect "SSID"
    ```
    

Exit with:

```bash
exit
```



#### Option 1: Use NetworkManager with iwd as the backend (recommended if you want GUI tools or easy management)

Edit `/etc/NetworkManager/NetworkManager.conf`:
```
[device]
wifi.backend=iwd
```

Restart NetworkManager:
```
sudo systemctl restart NetworkManager
```
Now, NetworkManager will use `iwd` instead of `wpa_supplicant` for Wi-Fi, and you can keep using `nmcli` or a GUI like `nm-applet`.

#### **Option 2: Let iwd handle both Wi-Fi and networking** (standalone mode)

Edit (or create) the config:
```
sudo nano /etc/iwd/main.conf
```

Add:
```
[Network]
EnableIPv6=true
```

Restart iwd:
```
sudo systemctl restart iwd
```


### if connected but no ping
Edit the config:
```
sudo nvim /etc/iwd/main.conf
```

Add:
```
[General]
EnableNetworkConfiguration=true

[Network]
NameResolvingService=systemd
```

Restart services:
```
sudo systemctl restart iwd
sudo systemctl restart systemd-resolved
```


Reconnect your Wi-Fi:
```
iwctl
station wlan0 disconnect
station wlan0 connect "SSID"
```

Now when you run:
```
station wlan0 show
```
