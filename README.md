# 2808-A658-fingerprint-arch-linux-driver
A complete setup guide and custom libfprint driver to get FocalTech fingerprint readers working seamlessly on Arch.


# Arch Linux FocalTech Fingerprint Driver

This repository provides a custom pre-compiled `libfprint` package to get FocalTech fingerprint sensors (commonly found in Asus laptops and similar hardware) working on Arch Linux. 

Because the original drivers were structured for Debian/Ubuntu environments, this setup relies on a custom package and involves manually linking the installed libraries to the correct Arch Linux directories.

## Prerequisites

Before starting, verify that your FocalTech fingerprint reader is detected by your system. Open your terminal and run:
```bash
lsusb
```
You should see a device listed as FocalTech in the output.

Download the repository and navigate into the folder where the package is located:
```bash
git clone [https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git](https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git)
cd YOUR_REPO_NAME
```

Install the standard fingerprint daemon
```bash
sudo pacman -S fprintd
```

Install the custom libfprint package
```bash
sudo pacman -U -dd --overwrite '*' libfprint.pkg.tar.zst
```

Fix the library path
```bash
sudo cp -a /usr/lib/x86_64-linux-gnu/libfprint-2* /usr/lib/
```

Restart the fingerprint daemon
```bash
sudo systemctl restart fprintd
```
Now fingerprint options will appear in your Settings -> System -> Users -> Fingerprint Login


To enable fingerprint authentication for sudo:
```bash
sudo nano /etc/pam.d/sudo
```

Add the following line to the very top of the file:
```bash
auth            sufficient      pam_fprintd.so
```
Save and exit.