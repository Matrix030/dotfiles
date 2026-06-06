# DNS Broken After Connecting (Quick Fix)

You're connected to Wi-Fi but names won't resolve.

## 1. Test raw connectivity

```bash
ping 8.8.8.8
```

- Works → internet is fine, only DNS is broken (continue below).
- Fails → it's a gateway or routing issue, not DNS.

## 2. Permanent fix

Enable `systemd-resolved` so DNS is always managed, and point `/etc/resolv.conf` at its stub:

```bash
sudo systemctl enable --now systemd-resolved
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
```

This survives reboots and keeps DNS stable.

> For the full DNS + university Wi-Fi walkthrough, see `iwctl_dns_issue_uni_wifi.md`.
