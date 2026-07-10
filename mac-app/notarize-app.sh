#!/bin/bash
#
# Produce a NOTARIZED Mori.app — no Gatekeeper "Not Opened" dialog for users.
#
# One-time setup (requires a paid Apple Developer account, $99/yr):
#   1. developer.apple.com → enroll → Certificates → create a
#      "Developer ID Application" certificate and install it in your Keychain
#      (easiest via Xcode → Settings → Accounts → Manage Certificates…).
#   2. appleid.apple.com → App-Specific Passwords → generate one, then:
#        xcrun notarytool store-credentials MoriNotary \
#          --apple-id "you@example.com" --team-id "TEAMID" --password "app-specific-pw"
#
# Then every release is just:   ./notarize-app.sh
# Output: release/dist/Mori-<version>-beta.zip  (signed, notarized, stapled)
#
set -euo pipefail
cd "$(dirname "$0")"

VERSION="0.1.0"
APP="build/Mori.app"
PROFILE="${MORI_NOTARY_PROFILE:-MoriNotary}"
OUT="release/dist/Mori-$VERSION-beta.zip"

# 1) Find the Developer ID Application identity automatically.
IDENTITY="${MORI_DEVELOPER_ID:-$(security find-identity -v -p codesigning \
  | grep -o '"Developer ID Application: [^"]*"' | head -1 | tr -d '"')}"
if [ -z "$IDENTITY" ]; then
  echo "✗ No 'Developer ID Application' certificate found in your Keychain."
  echo "  Complete the one-time setup in the header of this script, then re-run."
  exit 1
fi
echo "▸ Signing identity: $IDENTITY"

# 2) Fresh build.
echo "▸ Building…"
./build-app.sh >/dev/null
xattr -cr "$APP"

# 3) Sign with hardened runtime (required for notarization) + entitlements.
echo "▸ Signing (hardened runtime)…"
codesign --force --options runtime --timestamp \
  --entitlements Mori/Resources/Mori.entitlements \
  --sign "$IDENTITY" "$APP"
codesign --verify --strict --verbose=2 "$APP"

# 4) Submit to Apple for notarization and wait.
echo "▸ Notarizing (this takes a few minutes)…"
ditto -c -k --sequesterRsrc --keepParent "$APP" /tmp/Mori-notarize.zip
xcrun notarytool submit /tmp/Mori-notarize.zip --keychain-profile "$PROFILE" --wait
rm -f /tmp/Mori-notarize.zip

# 5) Staple the ticket so Gatekeeper approves even offline.
echo "▸ Stapling…"
xcrun stapler staple "$APP"
xcrun stapler validate "$APP"

# 6) Final zip for distribution.
mkdir -p release/dist
rm -f "$OUT"
ditto -c -k --sequesterRsrc --keepParent "$APP" "$OUT"

echo ""
echo "✓ Notarized build: $OUT"
echo "  SHA256: $(shasum -a 256 "$OUT" | cut -d' ' -f1)"
echo ""
echo "Next: cp \"$OUT\" ../public/downloads/  → update lib/site.ts sha256 → commit & push."
echo "Users will now open Mori with zero Gatekeeper dialogs."
