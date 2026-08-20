#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# shellcheck disable=SC1091
source "$ROOT/version.env"

DIST="$ROOT/dist"
APP="$DIST/DevWifiBar.app"
CONTENTS="$APP/Contents"
MACOS_DIR="$CONTENTS/MacOS"

rm -rf "$DIST"
mkdir -p "$MACOS_DIR" "$CONTENTS/Resources"

if [[ "${UNIVERSAL:-0}" == "1" ]]; then
  swift build -c release --product DevWifiBar --arch arm64
  swift build -c release --product DevWifiBar --arch x86_64
  ARM_BIN="$(swift build -c release --product DevWifiBar --arch arm64 --show-bin-path)/DevWifiBar"
  X86_BIN="$(swift build -c release --product DevWifiBar --arch x86_64 --show-bin-path)/DevWifiBar"
  lipo -create -output "$MACOS_DIR/DevWifiBar" "$ARM_BIN" "$X86_BIN"
else
  swift build -c release --product DevWifiBar
  BIN="$(swift build -c release --product DevWifiBar --show-bin-path)/DevWifiBar"
  cp "$BIN" "$MACOS_DIR/DevWifiBar"
fi

chmod +x "$MACOS_DIR/DevWifiBar"
cp "$ROOT/Sources/DevWifiBar/Info.plist" "$CONTENTS/Info.plist"

if [[ -x /usr/libexec/PlistBuddy ]]; then
  /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${VERSION}" "$CONTENTS/Info.plist"
  /usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${VERSION}" "$CONTENTS/Info.plist"
fi

printf 'APPL????' > "$CONTENTS/PkgInfo"
codesign --force --deep --sign - "$APP"

ZIP="$DIST/DevWifiBar-${VERSION}.zip"
ditto -c -k --keepParent "$APP" "$ZIP"

echo "Built $APP"
echo "Zipped $ZIP"
