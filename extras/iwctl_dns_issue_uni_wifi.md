## 📝 Fixing “DNS lookup failed on ::1:53” in Arch (quick run-down)

1. **Enable systemd-resolved** (DNS service in systemd):

   ```bash
   sudo systemctl enable --now systemd-resolved
   ```

2. **Point `/etc/resolv.conf` to resolved’s stub file** (so apps use it):

   ```bash
   sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
   ```

3. **Find your Wi-Fi interface name** (usually `wlan0`, `wlp2s0`, etc.):

   ```bash
   ip link show
   ```

4. **Set working DNS servers on that interface**:

   ```bash
   sudo resolvectl dns <iface> 1.1.1.1 8.8.8.8
   sudo resolvectl domain <iface> "~."
   sudo resolvectl flush-caches
   ```

5. **Verify DNS is working**:

   ```bash
   resolvectl status
   cat /etc/resolv.conf
   getent hosts proxy.golang.org
   ```

6. **Retry your Go command**:

   ```bash
   go install github.com/spf13/cobra/cobra@latest
   ```

### Why this works

* Before, `/etc/resolv.conf` was an **empty file from NetworkManager**, but NM wasn’t running → so no DNS.
* By enabling `systemd-resolved` and symlinking `/etc/resolv.conf`, DNS requests go through resolved.
* By explicitly setting DNS servers (Cloudflare + Google), you bypass campus/local misconfigs.




That’s the full fix cycle. Next time you hit this problem, just follow **steps 1–4**, then verify.

Do you want me to write this out as a **tiny script** (`fix-dns.sh`) you can run whenever DNS breaks?
