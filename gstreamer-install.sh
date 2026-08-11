#!/usr/bin/env bash

#
# install.sh
#
# Installs:
#   - build tools
#   - GTK4 development packages
#   - GStreamer development and plugin packages
#   - local Allwinner arm64 .deb packages
#   - copies libgstgtk4.so into GStreamer plugin directory
#
# Usage:
#   chmod +x install.sh
#   sudo ./install.sh
#
# NOTE:
#   These files are expected to be in the same directory as this script:
#     libcedarc-dev_2.0.0_arm64.deb
#     gstreamer1.0-omx-allwinner-config_1.18.3-1.1_arm64.deb
#     gstreamer1.0-omx-allwinner_1.18.3-1.1_arm64.deb
#     libgstgtk4.so
#

set -Eeuo pipefail

export DEBIAN_FRONTEND=noninteractive

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$(id -u)" -eq 0 ]]; then
    SUDO=""
else
    SUDO="sudo"
fi

trap 'echo "ERROR: install failed at line $LINENO" >&2' ERR

APT_PACKAGES=(
    build-essential
    cmake
    pkg-config
    libgtk-4-dev
    libgstreamer1.0-dev
    libgstreamer-plugins-base1.0-dev
    gstreamer1.0-tools
    gstreamer1.0-plugins-base
    gstreamer1.0-plugins-good
    gstreamer1.0-plugins-bad
    gstreamer1.0-plugins-ugly
)

LOCAL_DEBS=(
    libcedarc-dev_2.0.0_arm64.deb
    gstreamer1.0-omx-allwinner-config_1.18.3-1.1_arm64.deb
    gstreamer1.0-omx-allwinner_1.18.3-1.1_arm64.deb
)

LIBGSTGTK4_SO="libgstgtk4.so"
GST_PLUGIN_DIR="/usr/lib/aarch64-linux-gnu/gstreamer-1.0"

echo "==> Script directory: $SCRIPT_DIR"

echo "==> Checking architecture"
ARCH="$(dpkg --print-architecture || echo unknown)"
if [[ "$ARCH" != "arm64" ]]; then
    echo "WARNING: local packages are for arm64, but this system reports: $ARCH"
fi

echo "==> Checking required files"
MISSING=0
DEB_PATHS=()

for deb in "${LOCAL_DEBS[@]}"; do
    DEB_PATH="$SCRIPT_DIR/$deb"

    if [[ ! -f "$DEB_PATH" ]]; then
        echo "ERROR: missing file: $DEB_PATH" >&2
        MISSING=1
    else
        DEB_PATHS+=("$DEB_PATH")
    fi
done

if [[ ! -f "$SCRIPT_DIR/$LIBGSTGTK4_SO" ]]; then
    echo "ERROR: missing file: $SCRIPT_DIR/$LIBGSTGTK4_SO" >&2
    MISSING=1
fi

if [[ "$MISSING" -ne 0 ]]; then
    echo "" >&2
    echo "Place the required files in the same directory as this script," >&2
    echo "or edit the paths in this file." >&2
    exit 1
fi

echo "==> Updating apt package lists"
$SUDO apt-get update

echo "==> Installing APT packages"
$SUDO apt-get install -y "${APT_PACKAGES[@]}"

echo "==> Installing local .deb packages"
if ! $SUDO dpkg -i "${DEB_PATHS[@]}"; then
    echo "WARNING: dpkg reported problems. Attempting dependency repair..."
    $SUDO apt-get install -f -y
    $SUDO dpkg --configure -a
fi

echo "==> Copying $LIBGSTGTK4_SO to GStreamer plugin directory"
$SUDO mkdir -p "$GST_PLUGIN_DIR"
$SUDO cp "$SCRIPT_DIR/$LIBGSTGTK4_SO" "$GST_PLUGIN_DIR/"

echo "==> Done"