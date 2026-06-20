#!/usr/bin/env bash
# NVIDIA GPU showcase for waybar (RTX 4080 SUPER).
# Bar shows load %; tooltip showcases the full card: temp, VRAM, power, clocks.

read -r util temp mem_used mem_total power pstate gclk < <(
  nvidia-smi \
    --query-gpu=utilization.gpu,temperature.gpu,memory.used,memory.total,power.draw,pstate,clocks.gr \
    --format=csv,noheader,nounits 2>/dev/null | tr -d ',' )

if [ -z "$util" ]; then
  printf '{"text":"󰢮 n/a","tooltip":"nvidia-smi unavailable","class":"error"}\n'
  exit 0
fi

mem_pct=$(( mem_used * 100 / mem_total ))
tooltip="<b>GeForce RTX 4080 SUPER</b>\n  Load    ${util}%   (${pstate})\n  Temp    ${temp}°C\n  VRAM    ${mem_used} / ${mem_total} MiB  (${mem_pct}%)\n  Power   ${power} W\n  Clock   ${gclk} MHz"

printf '{"text":"<span size=\\"130%%\\">󰢮</span> %s%%","tooltip":"%s"}\n' "$util" "$tooltip"
