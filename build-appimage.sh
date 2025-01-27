
# WIP
#!/bin/bash

set -e

apt-get install -y locales
locale-gen en_US.UTF-8

# Set locale
# export LC_ALL=en_US.UTF-8
# export LANGUAGE=en_US.UTF-8
# export LANG=en_US.UTF-8

# Build .deb
# dpkg-buildpackage -b -us -uc

# Download appimagetool if not present
if [ ! -f appimagetool-x86_64.AppImage ]; then
    wget "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage"
    chmod +x appimagetool-x86_64.AppImage
fi

# Build AppImage
# Clean and prepare build directory
rm -rf AppDir build/
# mkdir -p AppDir

# Configure meson build
# meson setup build --wipe --prefix=/usr

# Build and install
# ninja -C build
# # DESTDIR=$(pwd)/AppDir 
# ninja -C build install

mkdir -p AppDir
meson setup build --prefix=/usr
# meson setup build
ninja -C build
DESTDIR=$(pwd)/AppDir ninja -C build install

# Build AppImage
# appimage-builder --recipe AppImageBuilder.yml
# Create AppRun script
cat > "AppDir/AppRun" << 'EOF'
#!/bin/bash
SELF=$(readlink -f "$0")
HERE=${SELF%/*}
export PATH="${HERE}/usr/bin/:${PATH}"
exec "${HERE}/usr/bin/pika-backup" "$@"
EOF
chmod +x "AppDir/AppRun"

cp "AppDir/usr/share/applications/org.gnome.World.PikaBackup.desktop" "AppDir/org.gnome.World.PikaBackup.desktop"
cp "AppDir/usr/share/applications/org.gnome.World.PikaBackup.Monitor.desktop" "AppDir/org.gnome.World.PikaBackup.Monitor.desktop"
cp "AppDir/usr/share/metainfo/org.gnome.World.PikaBackup.metainfo.xml" "AppDir/org.gnome.World.PikaBackup.metainfo.xml"
touch "AppDir/org.gnome.World.PikaBackup.png"
VERSION=$(grep version Cargo.toml | head -n1 | cut -d '"' -f2)
ARCH=$(uname -m)
./appimagetool-x86_64.AppImage --verbose AppDir/ "pika-backup-$ARCH-$VERSION.AppImage"


# sudo apt install debhelper devscripts appimage-builder