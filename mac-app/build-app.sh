#!/bin/bash
#
# Build Mori.app with ONLY the Xcode Command Line Tools — no Xcode.app, no Homebrew.
# Compiles the Swift sources, assembles a proper .app bundle, and ad-hoc signs it
# with the entitlements so macOS can grant Accessibility.
#
# Usage:   ./build-app.sh          then:   open build/Mori.app
#
set -euo pipefail
cd "$(dirname "$0")"

# Prefer the Command Line Tools toolchain when present: it builds without needing
# the Xcode license accepted. (If you'd rather use the Xcode toolchain, run
# `sudo xcodebuild -license accept` once and remove this block.)
if [ -d /Library/Developer/CommandLineTools ]; then
  export DEVELOPER_DIR=/Library/Developer/CommandLineTools
fi

APP_NAME="Mori"
SRC_DIR="Mori"
BUILD_DIR="build"
APP_BUNDLE="$BUILD_DIR/$APP_NAME.app"
CONTENTS="$APP_BUNDLE/Contents"
MACOS_DIR="$CONTENTS/MacOS"
RES_DIR="$CONTENTS/Resources"

SDK="$(xcrun --show-sdk-path --sdk macosx)"
ARCH="$(uname -m)"                    # arm64 (Apple Silicon) or x86_64 (Intel)
BUNDLE_ID="app.heymori.Mori"
VERSION="0.1.0"

echo "▸ Cleaning…"
rm -rf "$APP_BUNDLE"
mkdir -p "$MACOS_DIR" "$RES_DIR"

echo "▸ Compiling Swift sources ($ARCH, macOS 14 target)…"
# shellcheck disable=SC2046
swiftc -parse-as-library \
  -sdk "$SDK" \
  -target "${ARCH}-apple-macos14.0" \
  -o "$MACOS_DIR/$APP_NAME" \
  $(find "$SRC_DIR" -name '*.swift')

echo "▸ Writing Info.plist…"
cat > "$CONTENTS/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key><string>en</string>
	<key>CFBundleExecutable</key><string>${APP_NAME}</string>
	<key>CFBundleIdentifier</key><string>${BUNDLE_ID}</string>
	<key>CFBundleInfoDictionaryVersion</key><string>6.0</string>
	<key>CFBundleName</key><string>${APP_NAME}</string>
	<key>CFBundleDisplayName</key><string>${APP_NAME}</string>
	<key>CFBundlePackageType</key><string>APPL</string>
	<key>CFBundleShortVersionString</key><string>${VERSION}</string>
	<key>CFBundleVersion</key><string>1</string>
	<key>LSMinimumSystemVersion</key><string>14.0</string>
	<key>LSUIElement</key><true/>
	<key>CFBundleIconFile</key><string>Mori</string>
	<key>CFBundleIconName</key><string>AppIcon</string>
	<key>NSHumanReadableCopyright</key><string>Mori — a little memory spirit for your Mac.</string>
</dict>
</plist>
PLIST

printf 'APPL????' > "$CONTENTS/PkgInfo"

# App icon: generate once if missing, then embed the .icns.
if [ ! -f "$SRC_DIR/Resources/Mori.icns" ]; then
  echo "▸ Generating app icon…"
  ./Tools/gen-appicon.sh
fi
echo "▸ Embedding app icon…"
cp "$SRC_DIR/Resources/Mori.icns" "$RES_DIR/Mori.icns"

echo "▸ Stripping extended attributes…"
xattr -cr "$APP_BUNDLE"

# Signing identity. Default is ad-hoc ("-"), which changes every build — so
# macOS re-asks for Keychain access after each rebuild. To make "Always Allow"
# STICK across rebuilds, sign with a stable identity:
#
#   1) Keychain Access → Certificate Assistant → Create a Certificate…
#      Name: "Mori Dev"  ·  Identity Type: Self Signed Root  ·  Type: Code Signing
#   2) Build with it:   MORI_SIGN_IDENTITY="Mori Dev" ./build-app.sh
#
# (For a public beta, use a real "Developer ID Application" identity instead.)
SIGN_IDENTITY="${MORI_SIGN_IDENTITY:--}"
if [ "$SIGN_IDENTITY" = "-" ]; then
  echo "▸ Ad-hoc code signing (with entitlements)…"
else
  echo "▸ Code signing as '$SIGN_IDENTITY' (with entitlements)…"
fi
codesign --force --sign "$SIGN_IDENTITY" \
  --entitlements "$SRC_DIR/Resources/Mori.entitlements" \
  "$APP_BUNDLE"

# Finder/Spotlight can re-add a com.apple.FinderInfo xattr to the .app folder,
# which upsets `codesign --verify --strict`. It does NOT affect launching, but
# we clear it for a clean bill of health.
xattr -dr com.apple.FinderInfo "$APP_BUNDLE" 2>/dev/null || true

echo "▸ Verifying signature…"
codesign -dv "$APP_BUNDLE" 2>&1 | sed -n '1,3p' || true

echo ""
echo "✓ Built: $APP_BUNDLE"
echo "  Run it:      open \"$APP_BUNDLE\""
echo "  Menu bar:    look for the leaf icon (this is a menu-bar app, no Dock icon)"
echo "  Rebuild:     ./build-app.sh"
