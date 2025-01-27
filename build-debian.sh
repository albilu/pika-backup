#!/bin/bash

set -e

RELEASE_VERSION=0.7.4

# Update version in DEBIAN/control
sed -i "s/Version: .*/Version: $RELEASE_VERSION/" DEBIAN/control

apt update && apt install -y \
    wget build-essential rustc cargo libgtk-4-dev pkg-config libpango1.0-dev \
    libgraphene-1.0-dev \
    libadwaita-1-dev \
    fuse libgdk-pixbuf2.0-dev meson gettext itstool git gzip lintian

# Clone the repository
git clone --branch v$RELEASE_VERSION https://gitlab.gnome.org/World/pika-backup.git .

mkdir -p AppDir
meson setup build --wipe --prefix=/usr
ninja -C build
DESTDIR=$(pwd)/AppDir ninja -C build install

# Create changelog
mkdir -p AppDir/usr/share/doc/pika-backup
gzip -9 > AppDir/usr/share/doc/pika-backup/changelog.gz << EOF
pika-backup ($RELEASE_VERSION) unstable; urgency=medium

  * Custom Debian release

 -- albilu  $(date -R)
EOF

# Create copyright
cat > AppDir/usr/share/doc/pika-backup/copyright << EOF
Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: pika-backup
Source: https://gitlab.gnome.org/World/pika-backup

Files: *
License: GNU GENERAL PUBLIC LICENSE
EOF

strip AppDir/usr/bin/pika-backup
strip AppDir/usr/bin/pika-backup-monitor

# Set proper permissions
cp -r DEBIAN AppDir/
chmod 755 AppDir/DEBIAN
chmod 644 AppDir/DEBIAN/control

# Build the package
dpkg-deb --build AppDir pika-backup_${RELEASE_VERSION}_amd64.deb

# Verify the package
lintian pika-backup_${RELEASE_VERSION}_amd64.deb