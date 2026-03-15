# Maintainer: Meet Suthar <sutharmeet513@gmail.com>
pkgname=libfprint-2-2
pkgver=1
pkgrel=1
pkgdesc="Async fingerprint library of fprint project, with FocalTech sensor support"
arch=('x86_64')
url="https://www.freedesktop.org/wiki/Software/fprint/libfprint"
license=('custom')

# Cleaned up dependencies for Arch Linux compatibility
depends=('glib2>=2.56' 'glibc' 'gcc-libs' 'libgudev' 'libgusb>=0.3.0' 'nss' 'pixman')

# Crucial: This ensures pacman removes the standard libfprint to avoid file conflicts
provides=('libfprint')
conflicts=('libfprint')

# Links to the install script noted in your metadata
install="libfprint-2-2.install"

build() {
  # If compiling from source, put meson/make commands here.
  # If extracting a pre-compiled binary, you can often leave this function empty.
  true
}

package() {
  # This function copies the files into the Arch package structure.
  # e.g., cp -r "$srcdir/usr" "$pkgdir/"
  true
}