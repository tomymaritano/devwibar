#!/usr/bin/env bash
# One-time: store App Store Connect credentials for notarytool.
# Needs an app-specific password from appleid.apple.com (Sign-In and Security).
set -euo pipefail

PROFILE="${NOTARY_KEYCHAIN_PROFILE:-devwibar-notary}"
APPLE_ID="${APPLE_ID:-}"
TEAM_ID="${APPLE_TEAM_ID:-}"

if [[ -z "$APPLE_ID" ]]; then
  read -r -p "Apple ID email: " APPLE_ID
fi
if [[ -z "$TEAM_ID" ]]; then
  read -r -p "Team ID (developer.apple.com → Membership): " TEAM_ID
fi

xcrun notarytool store-credentials "$PROFILE" \
  --apple-id "$APPLE_ID" \
  --team-id "$TEAM_ID"

echo "Stored profile '$PROFILE'."
echo "Package with: NOTARY_KEYCHAIN_PROFILE=$PROFILE ./Scripts/package_app.sh"
