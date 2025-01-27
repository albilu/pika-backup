# Pika Backup

[![Build Status](https://github.com/albilu/pika-backup/workflows/Build/badge.svg)](https://github.com/albilu/pika-backup/actions)

This Repository fetches original source (https://gitlab.gnome.org/World/pika-backup) and create corresponding Debian package/Appimage for Pika Backup: Best Backup Utility for Linux but missing alternative packaging to flatpak.

## Available Packages

-   [x] Debian/Ubuntu (.deb)
-   [ ] AppImage (WIP)

## Building from Source

### Dependencies

-   rust/cargo
-   libgtk-4-dev (>= 4.12.5)
-   libadwaita-1-dev (>= 1.4.0)
-   meson
-   borgbackup

### Build Instructions

```bash
# Build Debian package
./build-debian.sh

# Build AppImage
./build-appimage.sh
```

## Installation

### Debian/Ubuntu

```bash
sudo dpkg -i pika-backup_*.deb
```

### AppImage

```bash
chmod +x pika-backup-*.AppImage
./pika-backup-*.AppImage
```

## License

GPL-3.0

## Credits

Original project: https://gitlab.gnome.org/World/pika-backup
