<div align="center">

# FocalTech Fingerprint Driver

### Make FocalTech fingerprint readers work on Arch Linux & Ubuntu

[![Platform](https://img.shields.io/badge/Platform-Arch%20Linux%20%7C%20Ubuntu-1793D1?style=for-the-badge&logo=linux&logoColor=white)](https://github.com/Meetsuthar32778/2808-A658-fingerprint-arch-linux-driver)
[![Shell](https://img.shields.io/badge/Shell-Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)](https://github.com/Meetsuthar32778/2808-A658-fingerprint-arch-linux-driver)
[![Stars](https://img.shields.io/github/stars/Meetsuthar32778/2808-A658-fingerprint-arch-linux-driver?style=for-the-badge&color=yellow)](https://github.com/Meetsuthar32778/2808-A658-fingerprint-arch-linux-driver/stargazers)

</div>

---

## 📖 Overview

FocalTech fingerprint sensors (USB ID `2808:A658`) — commonly found in **Asus laptops** and similar hardware — ship with drivers structured for Debian/Ubuntu environments. This means they don't work out-of-the-box on Arch Linux.

This repository provides:

- A **custom pre-compiled `libfprint` package** for Arch Linux
- A **one-script installer** for Ubuntu/Debian (22.04 and 24.04)
- Step-by-step instructions to enable **fingerprint login and sudo authentication**

---

## 🖥 Compatible Hardware

| Device | USB ID | Status |
|--------|--------|--------|
| Asus laptops (FocalTech sensor) | `2808:A658` | ✅ Confirmed working |
| Similar FocalTech readers | `2808:xxxx` | ⚠️ May work — test with `lsusb` |

> **Not sure if your device is compatible?** Run `lsusb` and look for a `FocalTech` or `2808` entry in the output.

---

## ⚡ Quick Start

Choose your OS below:

- [Arch Linux installation](#-arch-linux-installation)
- [Ubuntu / Debian installation](#-ubuntu--debian-installation)

---

## 🔵 Arch Linux Installation

### Step 1 — Verify your hardware

Open a terminal and run:

```bash
lsusb
```

Look for a line containing `FocalTech` or `ID 2808:a658`. If it's not there, your device either isn't connected or isn't supported.

### Step 2 — Clone the repository

```bash
git clone https://github.com/Meetsuthar32778/2808-A658-fingerprint-arch-linux-driver.git
cd 2808-A658-fingerprint-arch-linux-driver
```

### Step 3 — Install the fingerprint daemon

```bash
sudo pacman -S fprintd
```

### Step 4 — Install the custom libfprint package

```bash
sudo pacman -U -dd --overwrite '*' libfprint.pkg.tar.zst
```

> ⚠️ The `-dd` flag skips dependency checks. This is intentional — the custom package is structured for Debian but works on Arch with the path fix below.

### Step 5 — Fix the library path

```bash
sudo cp -a /usr/lib/x86_64-linux-gnu/libfprint-2* /usr/lib/
```

### Step 6 — Restart the fingerprint daemon

```bash
sudo systemctl restart fprintd
```

### Step 7 — Enroll your fingerprint

Go to **Settings → System → Users → Fingerprint Login** and enroll your finger.

---

## 🟠 Ubuntu / Debian Installation

An automated install script is included for **Ubuntu 22.04 and 24.04**. It extracts the driver files from the pre-compiled Arch package and places them in the correct directories for Debian-based systems automatically.

```bash
git clone https://github.com/Meetsuthar32778/2808-A658-fingerprint-arch-linux-driver.git
cd 2808-A658-fingerprint-arch-linux-driver
chmod +x install-ubuntu.sh
sudo ./install-ubuntu.sh
```

After the script completes, go to **Settings → Users → Fingerprint Login** to enroll.

---

## 🔐 Enable Fingerprint for `sudo`

Once fingerprint login works in Settings, you can also use it to authenticate `sudo` commands in the terminal.

**1. Open the sudo PAM config:**

```bash
sudo nano /etc/pam.d/sudo
```

**2. Add this line at the very top of the file** (above all existing lines):

```
auth    sufficient    pam_fprintd.so
```

**3. Save and exit** (`Ctrl+O`, `Enter`, `Ctrl+X`).

> ✅ Now running `sudo` will prompt for your fingerprint first. If it fails or times out, it falls back to your password automatically.

---

## 🛠 Troubleshooting

<details>
<summary><strong>Fingerprint option doesn't appear in Settings</strong></summary>

Make sure `fprintd` is running:

```bash
systemctl status fprintd
```

If it's inactive, start it:

```bash
sudo systemctl enable --now fprintd
```

</details>

<details>
<summary><strong>`lsusb` doesn't show my fingerprint reader</strong></summary>

Try unplugging and replugging the device (if external). For built-in sensors, check your BIOS/UEFI — some laptops require fingerprint readers to be explicitly enabled in BIOS settings.

</details>

<details>
<summary><strong>Library path error after install</strong></summary>

Run the copy command again and verify:

```bash
sudo cp -a /usr/lib/x86_64-linux-gnu/libfprint-2* /usr/lib/
ls /usr/lib/libfprint*
```

You should see `libfprint-2.so` in the output.

</details>

<details>
<summary><strong>sudo fingerprint prompt immediately fails</strong></summary>

Try enrolling a different finger in Settings first. Also ensure the PAM line is at the very top of `/etc/pam.d/sudo` — order matters.

</details>

---

## 🤝 Contributing

Found a new compatible device? Got it working on a different distro? Contributions are welcome.

1. Fork the repo
2. Create a branch: `git checkout -b fix/your-fix-name`
3. Commit your changes: `git commit -m "Add support for XYZ"`
4. Open a Pull Request

Please include your hardware info (`lsusb` output) and OS version in the PR description.

---

<div align="center">

Made with frustration and caffeine on Fedora Linux 🐧

If this helped you, consider leaving a ⭐ — it helps others find it!

</div>
