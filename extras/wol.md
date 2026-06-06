# Wake-on-LAN (WoL)

Power on a machine remotely by sending a magic packet to its Ethernet MAC address.

## On the target machine

### 1. Install ethtool

```bash
sudo pacman -S ethtool
```

### 2. Find the Ethernet interface

```bash
ip link
```

(e.g. `eno1`)

### 3. Check WoL support

```bash
sudo ethtool eno1
```

Look for:

```
Supports Wake-on: pumbg
Wake-on: d
```

- `Supports Wake-on: ...g` means the hardware supports magic-packet wake.
- `Wake-on: d` means it's currently **disabled**. Enable it with:

```bash
sudo ethtool -s eno1 wol g
```

> This setting often resets on reboot — make it persistent via a systemd service or a udev rule if you need it to survive restarts. Also enable WoL in the BIOS/UEFI.

## From another machine on the network

### Install wol and send the packet

```bash
sudo pacman -S wol
wol <MAC-ADDRESS>
```
