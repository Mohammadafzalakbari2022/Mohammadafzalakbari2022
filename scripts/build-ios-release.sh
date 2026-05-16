#!/usr/bin/env bash
# Release IPA with production API (Render). macOS + Xcode required.
# Usage:
#   ./scripts/build-ios-release.sh
#   ./scripts/build-ios-release.sh config/dart_defines_prod.json

set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEFINES_FILE="${1:-config/dart_defines_prod.json}"
DEFINES_PATH="$ROOT/$DEFINES_FILE"

if [[ ! -f "$DEFINES_PATH" ]]; then
  echo "Defines file not found: $DEFINES_PATH" >&2
  exit 1
fi

cd "$ROOT"
flutter pub get
flutter gen-l10n
echo "Building release IPA with $DEFINES_FILE ..."
flutter build ipa --release --dart-define-from-file="$DEFINES_FILE"
echo "Done. IPA under build/ios/ipa/"
