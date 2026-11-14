#!/usr/bin/env bash
# Rebuild the Evil-M5Tab5 distribution bins (M5Stack Tab5 = ESP32-P4 + ESP32-C6).
#
# Produces two files flashed in one USB pass by the web flasher / M5Burner / esptool:
#   1. evil-m5tab5-v<VER>-full.bin   -> P4 app, flashed at 0x0 (bootloader @ 0x2000)
#   2. evil-m5tab5-v<VER>-c6.spiffs.bin -> C6 esp-hosted image inside the SPIFFS
#      partition (0xc90000). On first boot the P4 reflashes the C6 over the internal
#      SDIO link (hosted OTA), so the user only ever flashes the P4.
#
# Requires: esptool v5+, mkspiffs (bundled in the M5 P4 core), the arduino-cli build
# artifacts of the Evil-M5Tab sketch, and the C6 network_adapter.bin.
set -euo pipefail
SK="${1:?usage: build-tab5.sh <arduino-build-dir> <c6-network_adapter.bin> [version]}"
C6="${2:?need the C6 network_adapter.bin path (esp-hosted-mcu slave build)}"
VER="${3:-1.5.8}"

DIR="$(cd "$(dirname "$0")/.." && pwd)/firmware/evil-tab5"
# Pin the search to the P4 toolchain data tree (override with CORE_DATA=...).
CORE_DATA="${CORE_DATA:-$HOME/cyber/dev/hardware/toolchain-p4/data}"
MK="$(find "$CORE_DATA" -path '*m5stack/tools/mkspiffs*' -name mkspiffs -type f 2>/dev/null | head -1 || true)"
BOOT_APP0="$(find "$CORE_DATA" -path '*m5stack*' -name boot_app0.bin 2>/dev/null | head -1 || true)"
mkdir -p "$DIR"

[ -n "$MK" ]        || { echo "mkspiffs introuvable (core P4 M5)"; exit 1; }
[ -n "$BOOT_APP0" ] || { echo "boot_app0.bin introuvable"; exit 1; }
[ -f "$C6" ]        || { echo "C6 bin introuvable: $C6"; exit 1; }

FULL="$DIR/evil-m5tab5-v${VER}-full.bin"
SPIF="$DIR/evil-m5tab5-v${VER}-c6.spiffs.bin"

# 1) App merge. Tab5 bootloader lives at 0x2000 (not 0x1000). Non-padded.
esptool --chip esp32p4 merge-bin -o "$FULL" \
  --flash-mode keep --flash-freq keep --flash-size 16MB \
  0x2000  "$SK/Evil-M5Tab.ino.bootloader.bin" \
  0x8000  "$SK/Evil-M5Tab.ino.partitions.bin" \
  0xe000  "$BOOT_APP0" \
  0x10000 "$SK/Evil-M5Tab.ino.bin"

# 2) C6 image -> SPIFFS partition image (3.6 MB @ 0xc90000), exposed as /c6_slave.bin.
TMP="$(mktemp -d)"
cp "$C6" "$TMP/c6_slave.bin"
"$MK" -c "$TMP" -b 4096 -p 256 -s 0x360000 "$SPIF"
rm -rf "$TMP"

echo "OK:"
echo "  $FULL ($(stat -c%s "$FULL") octets)  -> offset 0x0"
echo "  $SPIF ($(stat -c%s "$SPIF") octets)  -> offset 0xc90000"
