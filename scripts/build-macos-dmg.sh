#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERSION="${VERSION:-}"
if [[ -z "$VERSION" ]]; then
  if [[ -f "$ROOT_DIR/VERSION" ]]; then
    VERSION="$(cat "$ROOT_DIR/VERSION" | tr -d '[:space:]')"
  else
    VERSION="0.0.0"
  fi
fi

DIST_DIR="$ROOT_DIR/dist"
APP_NAME="Memo Tori"
APP_PATH="$DIST_DIR/$APP_NAME.app"
DMG_PATH="$DIST_DIR/memo-tori-${VERSION}-macos.dmg"

mkdir -p "$DIST_DIR"

bash "$ROOT_DIR/scripts/build-macos-app.sh"

if [[ ! -d "$APP_PATH" ]]; then
  echo "Error: App bundle not found: $APP_PATH" >&2
  exit 1
fi

STAGE_DIR="$(mktemp -d)"
cleanup() {
  rm -rf "$STAGE_DIR"
}
trap cleanup EXIT

cp -R "$APP_PATH" "$STAGE_DIR/"
ln -s /Applications "$STAGE_DIR/Applications"

hdiutil create \
  -volname "$APP_NAME" \
  -srcfolder "$STAGE_DIR" \
  -ov \
  -format UDZO \
  "$DMG_PATH" >/dev/null

echo "Built DMG: $DMG_PATH"
