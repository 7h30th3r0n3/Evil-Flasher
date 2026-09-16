#!/usr/bin/env bash
# Regénère le merged bin AWOK Dual Mini v2 (ESP32 classic) flashable à l'offset 0x0.
# Prérequis : esptool (v5+) et les artefacts de compilation arduino-cli du sketch awok.
set -euo pipefail
SK="${1:?usage: build-awok.sh <arduino-sketch-build-dir> [version]}"
VER="${2:-1.5.6}"
OUT="$(dirname "$0")/../firmware/awok-dual-mini-v2/awok-dual-mini-v2-v${VER}.bin"
BOOT_APP0="$(find "$HOME/.arduino15/packages/m5stack" -name boot_app0.bin | head -1)"

esptool --chip esp32 merge-bin -o "$OUT" \
  --flash-mode dio --flash-freq 80m --flash-size 16MB \
  0x1000  "$SK/awok.ino.bootloader.bin" \
  0x8000  "$SK/awok.ino.partitions.bin" \
  0xe000  "$BOOT_APP0" \
  0x10000 "$SK/awok.ino.bin"
echo "OK -> $OUT"
