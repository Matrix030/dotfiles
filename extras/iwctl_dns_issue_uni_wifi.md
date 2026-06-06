# University Wi-Fi: DNS Fix + eduroam (802.1X) with iwd

This note covers two related problems on Arch:

1. Fixing `DNS lookup failed on ::1:53` (DNS not resolving).
2. Connecting to enterprise Wi-Fi (e.g. eduroam) that requires 802.1X.

---

## Part 1 — Fix "DNS lookup failed on ::1:53"

### 1. Enable systemd-resolved

```bash
sudo systemctl enable --now systemd-resolved
```

### 2. Point /etc/resolv.conf at resolved's stub

```bash
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
```

### 3. Find your Wi-Fi interface

```bash
ip link show
```

Usually `wlan0`, `wlp2s0`, etc.

### 4. Set working DNS servers on that interface

```bash
sudo resolvectl dns <iface> 1.1.1.1 8.8.8.8
sudo resolvectl domain <iface> "~."
sudo resolvectl flush-caches
```

### 5. Verify

```bash
resolvectl status
cat /etc/resolv.conf
getent hosts proxy.golang.org
```

### 6. Retry whatever failed

```bash
go install github.com/spf13/cobra/cobra@latest
```

### Why this works

- The old `/etc/resolv.conf` was an empty file left by NetworkManager, but NM wasn't running — so there was no DNS.
- Enabling `systemd-resolved` and symlinking `/etc/resolv.conf` routes DNS through resolved.
- Setting explicit DNS servers (Cloudflare + Google) bypasses broken campus/local DNS.

> Next time, run steps 1–4 then verify.

---

## Part 2 — Connect to eduroam (802.1X) with iwd

### 1. Install and enable iwd

```bash
sudo pacman -S iwd
sudo systemctl enable --now iwd
```

### 2. Start the interactive shell and find your device

```bash
iwctl
```

Inside `iwctl`:

```bash
device list
```

Assume it's `wlan0`.

### 3. Scan for networks

```bash
station wlan0 scan
station wlan0 get-networks
```

Find your university SSID (e.g. `eduroam`).

### 4. Create an 802.1X profile

Enterprise Wi-Fi needs an iwd network profile in `/var/lib/iwd/`:

```bash
sudo nvim /var/lib/iwd/eduroam.8021x
```

Most universities (PEAP/MSCHAPv2):

```ini
[Security]
EAP-Method=PEAP
EAP-Identity=your_netid@university.edu
EAP-PEAP-Phase2-Method=MSCHAPV2
EAP-Password=yourpassword
```

Some use TTLS/PAP instead:

```ini
[Security]
EAP-Method=TTLS
EAP-Identity=your_netid@university.edu
EAP-TTLS-Phase2-Method=PAP
Passphrase=yourpassword
```

If your school requires a CA certificate, add:

```ini
EAP-PEAP-CACert=/etc/ssl/certs/your_university_ca.pem
```

### 5. Connect

Back in `iwctl`:

```bash
station wlan0 connect eduroam
```

If the profile is correct, iwd authenticates and will auto-connect to this SSID in the future.

---

## Note: conflicting network services

The eduroam steps only fail when NetworkManager, iwd, and wpa_supplicant are all enabled at the same time. Disable the others first:

```bash
sudo systemctl disable --now NetworkManager wpa_supplicant connman dhcpcd netctl
```

Then follow the steps in **iwctl (clean arch install)** — and don't forget to restart the iwd service.
