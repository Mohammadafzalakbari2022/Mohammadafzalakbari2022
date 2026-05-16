#!/usr/bin/env bash
# Release IPA with stacked dart-define-from-file. macOS + Xcode required.
# Usage:
#   ./scripts/build-ios-release.sh
#   ./scripts/build-ios-release.sh staging

set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENV="${1:-prod}"
BASE="$ROOT/config/dart_defines_base.json"
ENV_FILE="$ROOT/config/dart_defines_${ENV}.json"

for f in "$BASE" "$ENV_FILE"; do
  if [[ ! -f "$f" ]]; then
    echo "Defines file not found: $f" >&2
    exit 1
  fi
done

cd "$ROOT"
flutter pub get
flutter gen-l10n
echo "Building release IPA (base + $ENV) ..."
flutter build ipa --release \
  --dart-define-from-file="$BASE" \
  --dart-define-from-file="$ENV_FILE"
echo "Done. IPA under build/ios/ipa/"
