# Evil-Flasher

Web flasher for **[Evil-M5Project](https://github.com/7h30th3r0n3/Evil-M5Project)** — flashes the
firmware onto an ESP32 **straight from the browser** via the Web Serial API, no esptool and no
install. Includes the **AWOK Dual ESP32 Mini v2** port.

👉 **Site: https://7h30th3r0n3.github.io/Evil-Flasher/**

## Supported devices

| Device | Chip | Firmware | .bin source |
|---|---|---|---|
| AWOK Dual ESP32 Mini v2 | ESP32 | 1.5.6 | `firmware/` (merged, hosted here) |
| M5Cardputer | ESP32-S3 | 1.5.5 | raw Evil-M5Project |
| M5AtomS3 | ESP32-S3 | 1.1.7 | raw Evil-M5Project |
| M5Stack CoreS3 | ESP32-S3 | 1.1.9 | raw Evil-M5Project |
| M5Stack Core2 | ESP32 | 1.3.9 | raw Evil-M5Project |
| M5Stack Fire | ESP32 | 1.3.9 | raw Evil-M5Project |
| M5StickC Plus/Plus2 | ESP32 | beta | raw Evil-M5Project |
| CYD (Cheap Yellow Display) | ESP32 | beta | raw Evil-M5Project |

Works on **Chrome / Edge desktop only** (Web Serial). Not Firefox, Safari, iOS or Android.

## How it works

- `index.html`: single page, device selector + [ESP Web Tools](https://esphome.github.io/esp-web-tools/).
- `manifests/*.json`: one ESP Web Tools manifest per device (`chipFamily` + `.bin` at offset `0x0`).
- M5 firmwares are served over `raw.githubusercontent.com` from Evil-M5Project (CORS `*`, no copy).
- The AWOK firmware is a **merged bin** hosted in `firmware/` (generated from the arduino-cli build).

## Add / update a device

1. Add the `.bin` (full-flash image, offset 0) — either a raw URL or a file in `firmware/`.
2. Create/edit `manifests/<id>.json` with the correct `chipFamily`
   (`ESP32`, `ESP32-S2`, `ESP32-S3`, `ESP32-C3`…).
3. Add an entry to the `DEVICES` array in `index.html`.

## Rebuild the AWOK firmware

```sh
# from an arduino-cli build of the awok sketch (dir with awok.ino.bin/.bootloader.bin/.partitions.bin)
scripts/build-awok.sh /path/to/build 1.5.6
```

## Deployment

Push to `main` → the `.github/workflows/deploy.yml` workflow publishes to GitHub Pages.
(Repo → Settings → Pages → Source: **GitHub Actions**.)

---
Firmware © [7h30th3r0n3 / Evil-M5Project](https://github.com/7h30th3r0n3/Evil-M5Project).
For **ethical and authorized** network testing only.
