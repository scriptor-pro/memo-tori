#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_DIRNAME="$(basename "$ROOT_DIR")"
VERSION="$(cat "$ROOT_DIR/VERSION" | tr -d '\n')"
BUILD_DIR="$ROOT_DIR/dist/arch"
TARBALL="$BUILD_DIR/memo-tori-${VERSION}.tar.gz"

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

tar \
  --exclude=".git" \
  --exclude="dist" \
  --exclude="__pycache__" \
  --exclude=".venv" \
  --transform "s,^${REPO_DIRNAME},memo-tori-${VERSION}," \
  -czf "$TARBALL" \
  -C "$ROOT_DIR/.." \
  "$REPO_DIRNAME"

cp "$ROOT_DIR/packaging/arch/PKGBUILD" "$BUILD_DIR/PKGBUILD"

(
  cd "$BUILD_DIR"
  PKGVER="$VERSION" makepkg -f
)

echo "Built: $BUILD_DIR/memo-tori-${VERSION}-1-x86_64.pkg.tar.zst"
