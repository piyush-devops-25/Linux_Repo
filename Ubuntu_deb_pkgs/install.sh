#!/bin/bash

PACKAGE_NAME="$1"
if [ -z "$PACKAGE_NAME" ]; then
  echo "Usage: $0 <package-name>"
  exit 1
fi

BASE_DIR="$HOME/offline_packages"
DOWNLOAD_DIR="$BASE_DIR/$PACKAGE_NAME"

mkdir -p "$DOWNLOAD_DIR"
cd "$DOWNLOAD_DIR" || exit 1

echo "🔍 Gathering dependencies for: $PACKAGE_NAME"

apt-rdepends "$PACKAGE_NAME" \
  | grep -v "^ " \
  | grep -v "^PreDepends" \
  | awk '!seen[$0]++' > packages.txt

echo "⬇️  Downloading packages..."

while read -r pkg; do
  echo "Downloading: $pkg"
  apt-get download "$pkg"
done < packages.txt

echo "✅ All .deb files downloaded to: $DOWNLOAD_DIR"
