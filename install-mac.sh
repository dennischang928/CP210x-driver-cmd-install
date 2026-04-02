#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This installer is for macOS only."
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required but not installed."
  exit 1
fi

if ! command -v unzip >/dev/null 2>&1; then
  echo "unzip is required but not installed."
  exit 1
fi

workdir="$(mktemp -d)"
cleanup() {
  rm -rf "$workdir"
}
trap cleanup EXIT

zip_path="$workdir/Mac_OSX_VCP_Driver.zip"
extract_dir="$workdir/extracted"

mkdir -p "$extract_dir"

echo "Downloading Silicon Labs CP210x macOS driver..."
curl -fL "https://www.silabs.com/documents/public/software/Mac_OSX_VCP_Driver.zip" -o "$zip_path"

echo "Extracting package..."
unzip -q "$zip_path" -d "$extract_dir"

pkg_path="$(find "$extract_dir" -type f -name "*.pkg" | head -n 1)"

if [[ -z "$pkg_path" ]]; then
  echo "No .pkg installer found in downloaded archive."
  exit 1
fi

echo "Installing package (administrator password may be required)..."
sudo installer -pkg "$pkg_path" -target /

echo "CP210x macOS driver installation completed."
echo "If prompted by macOS security settings, approve the system extension and reboot if required."
