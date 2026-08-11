# GStreamer Allwinner Install Script

This repository contains a Bash installation script for setting up GStreamer-related packages, GTK4 development libraries, and local Allwinner `arm64` / `aarch64` packages on Debian/Ubuntu-based systems. This script dedicated for Orange Pi 4 Pro (another version of SBC may work, I cannot guarantee it)

The script also copies a custom `libgstgtk4.so` GStreamer plugin into the system GStreamer plugin directory.

---

## Repository Files

Make sure the following files are placed in the same directory as `install.sh`:

```text
install.sh
libcedarc-dev_2.0.0_arm64.deb
gstreamer1.0-omx-allwinner-config_1.18.3-1.1_arm64.deb
gstreamer1.0-omx-allwinner_1.18.3-1.1_arm64.deb
libgstgtk4.so
README.md
```

---

## What This Script Does

The `install.sh` script will:

1. Update APT package lists.
2. Install build tools and development packages:
   - `build-essential`
   - `cmake`
   - `pkg-config`
   - GTK4 development libraries
   - GStreamer development libraries
3. Install GStreamer plugin packages:
   - `gstreamer1.0-tools`
   - `gstreamer1.0-plugins-base`
   - `gstreamer1.0-plugins-good`
   - `gstreamer1.0-plugins-bad`
   - `gstreamer1.0-plugins-ugly`
4. Install local Allwinner `.deb` packages:
   - `libcedarc-dev_2.0.0_arm64.deb`
   - `gstreamer1.0-omx-allwinner-config_1.18.3-1.1_arm64.deb`
   - `gstreamer1.0-omx-allwinner_1.18.3-1.1_arm64.deb`
5. Attempt to fix missing dependencies if `dpkg` fails.
6. Copy `libgstgtk4.so` to:

```text
/usr/lib/aarch64-linux-gnu/gstreamer-1.0/
```

---

## Supported Platform

This script is intended for:

- Debian-based ARM64 systems
- Ubuntu ARM64 systems
- `aarch64` / `arm64` architecture

Example:

```bash
uname -m
```

Expected output:

```text
aarch64
```

You can also check your APT architecture:

```bash
dpkg --print-architecture
```

Expected output:

```text
arm64
```

---

## Requirements

Before running the script, make sure you have:

- A Debian/Ubuntu-based ARM64 system
- Internet access
- `sudo` privileges
- All required files in the repository directory
- Enough disk space for package installation

---

## Usage

### 1. Clone the repository

```bash
git clone https://github.com/thanhtantran/gstreamer-install-orangepi4pro
cd gstreamer-install-orangepi4pro
```

---

### 2. Make the script executable

```bash
chmod +x install.sh
```

---

### 3. Run the installer

```bash
sudo ./install.sh
```

---

## Usage From ZIP Download

If you download the repository as a ZIP file from GitHub:

```bash
unzip gstreamer-install-orangepi4pro.zip
cd gstreamer-install-orangepi4pro
chmod +x install.sh
sudo ./install.sh
```

---

## Verification

After installation, check that GStreamer is available:

```bash
gst-inspect-1.0 --version
```

Check that the GTK4 GStreamer library was copied:

```bash
ls -l /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstgtk4.so
```

You can also try inspecting the plugin directly:

```bash
gst-inspect-1.0 /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstgtk4.so
```

---

## Troubleshooting

### Missing file error

If you see an error like:

```text
ERROR: missing file: /path/to/libcedarc-dev_2.0.0_arm64.deb
```

Make sure all required files are in the same directory as `install.sh`.

---

### Dependency errors during `.deb` installation

If `dpkg` fails because of missing dependencies, the script will automatically try:

```bash
sudo apt-get install -f -y
sudo dpkg --configure -a
```

If it still fails, read the package error message carefully. One of the local `.deb` packages may require another package that is not installed.

---

### Wrong architecture warning

If you see:

```text
WARNING: local packages are for arm64, but this system reports: amd64
```

You are running the script on a non-ARM64 system. The local Allwinner packages are intended for `arm64` / `aarch64` systems.

---

### GStreamer cannot find the plugin

Check the plugin file exists:

```bash
ls -l /usr/lib/aarch64-linux-gnu/gstreamer-1.0/libgstgtk4.so
```

You can also force GStreamer to rescan plugins:

```bash
rm -rf ~/.cache/gstreamer-1.0
gst-inspect-1.0
```

---

## License

Add a license if desired.

For example:

- MIT

If you do not add a license, default copyright laws apply on GitHub.

---

## Disclaimer

This script is provided as-is. Review the script before running it, especially if you are using it on a production system.