#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [[ -z "${VERSION:-}" ]]; then
  if [[ -f "$ROOT_DIR/VERSION" ]]; then
    VERSION="$(cat "$ROOT_DIR/VERSION")"
  else
    VERSION="0.1.0"
  fi
fi
ARCH="${ARCH:-$(dpkg --print-architecture)}"
BUILD_DIR="$ROOT_DIR/dist"
STAGE_DIR="$BUILD_DIR/memo-tori_${VERSION}_${ARCH}"

rm -rf "$STAGE_DIR"
mkdir -p \
  "$STAGE_DIR/DEBIAN" \
  "$STAGE_DIR/opt/memo-tori" \
  "$STAGE_DIR/usr/share/applications" \
  "$STAGE_DIR/usr/share/icons/hicolor/512x512/apps"

cp -a "$ROOT_DIR/memo-tori.py" "$STAGE_DIR/opt/memo-tori/"
cp -a "$ROOT_DIR/web" "$STAGE_DIR/opt/memo-tori/"
cp -a "$ROOT_DIR/assets" "$STAGE_DIR/opt/memo-tori/"
cp -a "$ROOT_DIR/requirements.txt" "$STAGE_DIR/opt/memo-tori/"

python3 -m venv --system-site-packages "$STAGE_DIR/opt/memo-tori/.venv"
"$STAGE_DIR/opt/memo-tori/.venv/bin/pip" install --no-cache-dir -r "$ROOT_DIR/requirements.txt"

sed \
  -e "s/__VERSION__/${VERSION}/" \
  -e "s/__ARCH__/${ARCH}/" \
  "$ROOT_DIR/packaging/deb/control" \
  > "$STAGE_DIR/DEBIAN/control"

if [[ -f "$ROOT_DIR/packaging/deb/postinst" ]]; then
  install -m 755 "$ROOT_DIR/packaging/deb/postinst" "$STAGE_DIR/DEBIAN/postinst"
fi

install -m 644 "$ROOT_DIR/packaging/deb/memo-tori.desktop" \
  "$STAGE_DIR/usr/share/applications/memo-tori.desktop"
install -m 644 "$ROOT_DIR/assets/icon.png" \
  "$STAGE_DIR/usr/share/icons/hicolor/512x512/apps/memo-tori.png"

mkdir -p "$BUILD_DIR"
dpkg-deb --build "$STAGE_DIR" "$BUILD_DIR/memo-tori_${VERSION}_${ARCH}.deb"

echo "Built: $BUILD_DIR/memo-tori_${VERSION}_${ARCH}.deb"
