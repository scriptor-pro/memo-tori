#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_DIRNAME="$(basename "$ROOT_DIR")"
VERSION="$(cat "$ROOT_DIR/VERSION" | tr -d '\n' | tr -d '[:space:]')"

if ! command -v rpmbuild >/dev/null 2>&1; then
  echo "Error: rpmbuild not found." >&2
  echo "Install hints:" >&2
  echo "  - Debian/Ubuntu/MX: sudo apt install -y rpm" >&2
  echo "  - Fedora/RHEL:      sudo dnf install -y rpm-build" >&2
  echo "  - Arch:             sudo pacman -S --needed rpm-tools" >&2
  exit 1
fi

RPM_TOPDIR="$ROOT_DIR/dist/rpm"
SOURCES_DIR="$RPM_TOPDIR/SOURCES"
SPECS_DIR="$RPM_TOPDIR/SPECS"

mkdir -p "$SOURCES_DIR" "$SPECS_DIR" "$RPM_TOPDIR/BUILD" "$RPM_TOPDIR/BUILDROOT" "$RPM_TOPDIR/RPMS" "$RPM_TOPDIR/SRPMS"

TARBALL_NAME="memo-tori-${VERSION}.tar.gz"
TARBALL_PATH="$SOURCES_DIR/$TARBALL_NAME"

echo "Building RPM for Memo Tori v$VERSION"

tar \
  --exclude=".git" \
  --exclude="dist" \
  --exclude="__pycache__" \
  --exclude=".venv" \
  --exclude=".venv-*" \
  --exclude="htmlcov" \
  --exclude=".pytest_cache" \
  --transform "s,^${REPO_DIRNAME},memo-tori-${VERSION}," \
  -czf "$TARBALL_PATH" \
  -C "$ROOT_DIR/.." \
  "$REPO_DIRNAME"

SPEC_TEMPLATE="$ROOT_DIR/packaging/rpm/memo-tori.spec.in"
SPEC_PATH="$SPECS_DIR/memo-tori.spec"

if [ ! -f "$SPEC_TEMPLATE" ]; then
  echo "Error: Spec template not found: $SPEC_TEMPLATE" >&2
  exit 1
fi

sed "s/@VERSION@/${VERSION}/g" "$SPEC_TEMPLATE" > "$SPEC_PATH"

rpmbuild \
  --define "_topdir $RPM_TOPDIR" \
  -ba "$SPEC_PATH"

echo "RPM build output (RPMS):"
find "$RPM_TOPDIR/RPMS" -type f -maxdepth 3 -print
