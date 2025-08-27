Step 1: Test raw connectivity
```
ping 8.8.8.8
```
- If this works → internet is fine, only DNS is broken.
- If it doesn’t → gateway or routing issue.

Permanent Fix
Enable `systemd-resolved` so DNS is always managed:
```
sudo systemctl enable --now systemd-resolved
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
```

That will survive reboots and keep DNS stable.
