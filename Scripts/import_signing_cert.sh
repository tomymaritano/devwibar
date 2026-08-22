#!/usr/bin/env bash
# Import CSC_LINK (base64 PKCS#12 or a file path) into a throwaway keychain.
# Secret names match dripnex/app so the same Developer ID can be reused.
set -euo pipefail

if [[ -z "${CSC_LINK:-}" ]]; then
  echo "import_signing_cert: CSC_LINK is empty" >&2
  exit 1
fi
if [[ -z "${CSC_KEY_PASSWORD:-}" ]]; then
  echo "import_signing_cert: CSC_KEY_PASSWORD is empty" >&2
  exit 1
fi

TMP="${RUNNER_TEMP:-$(mktemp -d)}"
CERT="$TMP/developer-id.p12"
KEYCHAIN="$TMP/signing.keychain-db"
PASSWORD="$(openssl rand -base64 32)"

if [[ -f "$CSC_LINK" ]]; then
  cp "$CSC_LINK" "$CERT"
else
  printf '%s' "$CSC_LINK" | tr -d '\n\r ' | base64 --decode > "$CERT"
fi

if [[ ! -s "$CERT" ]]; then
  echo "import_signing_cert: certificate is empty after decode" >&2
  exit 1
fi

security create-keychain -p "$PASSWORD" "$KEYCHAIN"
security set-keychain-settings -lut 21600 "$KEYCHAIN"
security unlock-keychain -p "$PASSWORD" "$KEYCHAIN"
security import "$CERT" -k "$KEYCHAIN" -P "$CSC_KEY_PASSWORD" -A \
  -T /usr/bin/codesign -T /usr/bin/security -T /usr/bin/productbuild
security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k "$PASSWORD" "$KEYCHAIN" >/dev/null

existing="$(security list-keychains -d user | sed 's/"//g')"
# shellcheck disable=SC2086
security list-keychains -d user -s "$KEYCHAIN" $existing
rm -f "$CERT"

IDENTITY="$(security find-identity -v -p codesigning "$KEYCHAIN" \
  | awk -F'"' '/Developer ID Application/ { print $2; exit }')"
if [[ -z "$IDENTITY" ]]; then
  echo "import_signing_cert: no Developer ID Application identity in CSC_LINK" >&2
  security find-identity -v -p codesigning "$KEYCHAIN" || true
  exit 1
fi

echo "Imported $IDENTITY"
if [[ -n "${GITHUB_ENV:-}" ]]; then
  echo "DEVELOPER_ID=$IDENTITY" >> "$GITHUB_ENV"
fi
