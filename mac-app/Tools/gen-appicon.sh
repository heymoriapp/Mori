#!/bin/bash
#
# Generate the Mori app icon (Mori.icns + AppIcon.appiconset) from the shared
# landing-page icon design, using only Command Line Tools (swift, iconutil).
#
set -euo pipefail
cd "$(dirname "$0")/.."   # mac-app/

if [ -d /Library/Developer/CommandLineTools ]; then
  export DEVELOPER_DIR=/Library/Developer/CommandLineTools
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "▸ Rendering icon PNGs…"
swift Tools/MakeAppIcon.swift "$TMP"

echo "▸ Building Mori.icns…"
ICONSET="$TMP/Mori.iconset"
mkdir -p "$ICONSET"
cp "$TMP/16.png"   "$ICONSET/icon_16x16.png"
cp "$TMP/32.png"   "$ICONSET/icon_16x16@2x.png"
cp "$TMP/32.png"   "$ICONSET/icon_32x32.png"
cp "$TMP/64.png"   "$ICONSET/icon_32x32@2x.png"
cp "$TMP/128.png"  "$ICONSET/icon_128x128.png"
cp "$TMP/256.png"  "$ICONSET/icon_128x128@2x.png"
cp "$TMP/256.png"  "$ICONSET/icon_256x256.png"
cp "$TMP/512.png"  "$ICONSET/icon_256x256@2x.png"
cp "$TMP/512.png"  "$ICONSET/icon_512x512.png"
cp "$TMP/1024.png" "$ICONSET/icon_512x512@2x.png"
iconutil -c icns "$ICONSET" -o Mori/Resources/Mori.icns

echo "▸ Populating AppIcon.appiconset (for Xcode builds)…"
AIS="Mori/Resources/Assets.xcassets/AppIcon.appiconset"
mkdir -p "$AIS"
cp "$TMP/16.png"   "$AIS/icon_16.png"
cp "$TMP/32.png"   "$AIS/icon_32.png"
cp "$TMP/64.png"   "$AIS/icon_64.png"
cp "$TMP/128.png"  "$AIS/icon_128.png"
cp "$TMP/256.png"  "$AIS/icon_256.png"
cp "$TMP/512.png"  "$AIS/icon_512.png"
cp "$TMP/1024.png" "$AIS/icon_1024.png"

cat > "$AIS/Contents.json" <<'JSON'
{
  "images" : [
    { "idiom" : "mac", "scale" : "1x", "size" : "16x16",   "filename" : "icon_16.png" },
    { "idiom" : "mac", "scale" : "2x", "size" : "16x16",   "filename" : "icon_32.png" },
    { "idiom" : "mac", "scale" : "1x", "size" : "32x32",   "filename" : "icon_32.png" },
    { "idiom" : "mac", "scale" : "2x", "size" : "32x32",   "filename" : "icon_64.png" },
    { "idiom" : "mac", "scale" : "1x", "size" : "128x128", "filename" : "icon_128.png" },
    { "idiom" : "mac", "scale" : "2x", "size" : "128x128", "filename" : "icon_256.png" },
    { "idiom" : "mac", "scale" : "1x", "size" : "256x256", "filename" : "icon_256.png" },
    { "idiom" : "mac", "scale" : "2x", "size" : "256x256", "filename" : "icon_512.png" },
    { "idiom" : "mac", "scale" : "1x", "size" : "512x512", "filename" : "icon_512.png" },
    { "idiom" : "mac", "scale" : "2x", "size" : "512x512", "filename" : "icon_1024.png" }
  ],
  "info" : { "author" : "xcode", "version" : 1 }
}
JSON

echo "✓ Icon generated: Mori/Resources/Mori.icns"
