# Wi-Fi Blocked by rfkill

If `wlan0` won't come up, it may be soft- or hard-blocked by rfkill.

## 1. Check the rfkill status

```bash
rfkill list
```

Example output:

```
0: phy0: Wireless LAN
    Soft blocked: yes
    Hard blocked: no
```

- **Soft blocked: yes** → disabled in software (fixable with `rfkill`).
- **Hard blocked: yes** → disabled by hardware (a laptop switch or BIOS setting).

## 2. If soft-blocked, unblock it

```bash
sudo rfkill unblock all
```

Or just Wi-Fi:

```bash
sudo rfkill unblock wifi
```

## 3. If hard-blocked

- Check for a physical Wi-Fi switch or function key (Fn + F2/F3, airplane mode, etc.).
- Make sure Wi-Fi is enabled in the BIOS/UEFI settings.

## 4. Bring the interface up

```bash
sudo ip link set wlan0 up
```

## 5. Retry with iwctl

```bash
iwctl
device list
```

In short: unblock with `rfkill`, then re-enable the interface.
