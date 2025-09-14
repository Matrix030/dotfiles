
1. Check the RF-kill status:
   ```bash
   rfkill list
   ```

   You’ll see something like:

   ```
   0: phy0: Wireless LAN
       Soft blocked: yes
       Hard blocked: no
   ```

   * **Soft blocked: yes** → disabled in software.
   * **Hard blocked: yes** → disabled by hardware switch (a key on your laptop, or a BIOS setting).

2. If it’s soft-blocked, unblock it:

   ```bash
   sudo rfkill unblock all
   ```

   or just Wi-Fi:

   ```bash
   sudo rfkill unblock wifi
   ```

3. If it’s hard-blocked:

   * Check if your laptop has a physical **Wi-Fi switch** or **function key** (Fn + F2/F3, airplane mode, etc.).
   * Make sure Wi-Fi is enabled in the BIOS/UEFI settings.

4. Once unblocked, bring it back up:

   ```bash
   sudo ip link set wlan0 up
   ```

5. Then retry with `iwctl`:

   ```bash
   iwctl
   device list
   ```

⚡ In short: unblock with `rfkill`, then re-enable.

Do you want me to also show you how to make sure `rfkill` unblocks automatically at boot so you don’t need to run it manually every time?

