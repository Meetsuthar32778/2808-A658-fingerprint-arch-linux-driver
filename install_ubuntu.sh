#!/bin/bash

set -e

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (e.g., using sudo)"
  exit 1
fi

echo "=========================================================="
echo " FocalTech Fingerprint Driver Installer for Ubuntu/Debian "
echo "=========================================================="

echo "1. Installing required standard packages (fprintd, libpam-fprintd, zstd)..."
apt update
apt install -y fprintd libpam-fprintd zstd tar patchelf

echo "2. Extracting the pre-compiled driver package..."
# We use a temporary directory for safe extraction
TMP_DIR=$(mktemp -d)
tar -I zstd -xf libfprint.pkg.tar.zst -C "$TMP_DIR"

echo "3. Patching libgusb symbol versions in the driver for modern Ubuntu..."
# The pre-compiled driver expects LIBGUSB_0.1.0, but newer Ubuntu uses LIBGUSB_0.2.8.
# By clearing the symbol version constraint using patchelf, the driver will correctly 
# link to the modern symbols dynamically without complaining about version mismatches.
patchelf --clear-symbol-version g_usb_device_get_release \
         --clear-symbol-version g_usb_interface_get_class \
         --clear-symbol-version g_usb_interface_get_subclass \
         --clear-symbol-version g_usb_device_get_interfaces \
         --clear-symbol-version g_usb_interface_get_protocol \
         --clear-symbol-version g_usb_interface_get_number \
         "$TMP_DIR/usr/lib/x86_64-linux-gnu/libfprint-2.so.2.0.0"

echo "4. Installing custom libfprint shared libraries..."
# The zst contains files inside usr/lib/x86_64-linux-gnu/
cp -a "$TMP_DIR/usr/lib/x86_64-linux-gnu/libfprint-2"* /usr/lib/x86_64-linux-gnu/

echo "4. Installing udev rules..."
cp -a "$TMP_DIR/usr/lib/udev/rules.d/60-libfprint-2.rules" /etc/udev/rules.d/

echo "5. Reloading udev rules and restarting fprintd service..."
udevadm control --reload-rules
udevadm trigger
systemctl restart fprintd

echo "6. Cleaning up..."
rm -rf "$TMP_DIR"

echo "=========================================================="
echo " Installation Complete! "
echo " You can now register your fingerprints by going to:"
echo " Settings -> System -> Users -> Fingerprint Login"
echo " "
echo " To enable fingerprint authentication for sudo, run:"
echo " sudo pam-auth-update"
echo " And ensure 'Fingerprint authentication' is checked."
echo "=========================================================="
