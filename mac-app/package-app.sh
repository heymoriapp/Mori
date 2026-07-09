#!/bin/bash
#
# Package Mori.app into a distributable zip for the private beta.
# Uses only Command Line Tools.  Output: release/dist/Mori-<version>-beta.zip
#
set -euo pipefail
cd "$(dirname "$0")"

if [ -d /Library/Developer/CommandLineTools ]; then
  export DEVELOPER_DIR=/Library/Developer/CommandLineTools
fi

VERSION="0.1.0"
APP="build/Mori.app"
OUT="release/dist"
ZIP="$OUT/Mori-$VERSION-beta.zip"

echo "▸ Building a fresh Mori.app…"
./build-app.sh >/dev/null

echo "▸ Stripping extended attributes…"
xattr -cr "$APP"

mkdir -p "$OUT"
rm -f "$ZIP"

echo "▸ Zipping the bundle (ditto preserves the .app correctly)…"
ditto -c -k --sequesterRsrc --keepParent "$APP" "$ZIP"

echo ""
echo "✓ Packaged: $ZIP"
echo "  Size:   $(du -h "$ZIP" | cut -f1)"
echo "  SHA256: $(shasum -a 256 "$ZIP" | cut -d' ' -f1)"
echo ""
echo "Note: this build is ad-hoc signed. Testers will need to right-click →"
echo "Open the first time (see release/INSTALL.md). For a smooth install, sign"
echo "with a Developer ID certificate and notarize (steps in release/INSTALL.md)."
