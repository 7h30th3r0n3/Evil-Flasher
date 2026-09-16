# Evil-Flasher

Web flasher pour **[Evil-M5Project](https://github.com/7h30th3r0n3/Evil-M5Project)** — flashe le
firmware sur un ESP32 **directement depuis le navigateur** via l'API Web Serial, sans esptool ni
installation. Inclut le portage **AWOK Dual ESP32 Mini v2**.

👉 **Site : https://7h30th3r0n3.github.io/Evil-Flasher/**

## Appareils supportés

| Appareil | Puce | Firmware | Source du .bin |
|---|---|---|---|
| AWOK Dual ESP32 Mini v2 | ESP32 | 1.5.6 | `firmware/` (merged, hébergé ici) |
| M5Cardputer | ESP32-S3 | 1.5.5 | raw Evil-M5Project |
| M5AtomS3 | ESP32-S3 | 1.1.7 | raw Evil-M5Project |
| M5Stack CoreS3 | ESP32-S3 | 1.1.9 | raw Evil-M5Project |
| M5Stack Core2 | ESP32 | 1.3.9 | raw Evil-M5Project |
| M5Stack Fire | ESP32 | 1.3.9 | raw Evil-M5Project |
| M5StickC Plus/Plus2 | ESP32 | beta | raw Evil-M5Project |
| CYD (Cheap Yellow Display) | ESP32 | beta | raw Evil-M5Project |

Compatible **Chrome / Edge desktop** uniquement (Web Serial). Pas Firefox, Safari, iOS ni Android.

## Comment ça marche

- `index.html` : page unique, sélecteur d'appareil + [ESP Web Tools](https://esphome.github.io/esp-web-tools/).
- `manifests/*.json` : un manifest ESP Web Tools par appareil (`chipFamily` + `.bin` à l'offset `0x0`).
- Les firmwares M5 sont servis en `raw.githubusercontent.com` depuis Evil-M5Project (CORS `*`, pas de copie).
- Le firmware AWOK est un **merged bin** hébergé dans `firmware/` (généré depuis le build arduino-cli).

## Ajouter / mettre à jour un appareil

1. Ajoutez le `.bin` (image pleine-flash, offset 0) — soit une URL raw, soit dans `firmware/`.
2. Créez/éditez `manifests/<id>.json` avec le bon `chipFamily`
   (`ESP32`, `ESP32-S2`, `ESP32-S3`, `ESP32-C3`…).
3. Ajoutez une entrée dans le tableau `DEVICES` de `index.html`.

## Régénérer le firmware AWOK

```sh
# depuis un build arduino-cli du sketch awok (dossier contenant awok.ino.bin/.bootloader.bin/.partitions.bin)
scripts/build-awok.sh /chemin/vers/build 1.5.6
```

## Déploiement

Push sur `main` → le workflow `.github/workflows/deploy.yml` publie sur GitHub Pages.
(Repo → Settings → Pages → Source: **GitHub Actions**.)

---
Firmware © [7h30th3r0n3 / Evil-M5Project](https://github.com/7h30th3r0n3/Evil-M5Project).
Outil réservé aux tests réseau **éthiques et autorisés**.
