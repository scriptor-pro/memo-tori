#!/bin/bash
# Prepare a new release of Memo Tori
# This script helps automate the release preparation process

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$ROOT_DIR"

echo "=================================="
echo "Memo Tori Release Preparation"
echo "=================================="
echo ""

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Not in a git repository"
    exit 1
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo "Warning: You have uncommitted changes"
    git status --short
    echo ""
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborting"
        exit 1
    fi
fi

# Read current version
if [ ! -f "VERSION" ]; then
    echo "Error: VERSION file not found"
    exit 1
fi

CURRENT_VERSION=$(cat VERSION | tr -d '[:space:]')
echo "Current version: $CURRENT_VERSION"
echo ""

# Ask for new version
read -p "Enter new version (or press Enter to keep $CURRENT_VERSION): " NEW_VERSION
NEW_VERSION=${NEW_VERSION:-$CURRENT_VERSION}

if [ "$NEW_VERSION" != "$CURRENT_VERSION" ]; then
    echo "$NEW_VERSION" > VERSION
    echo "Updated VERSION file to: $NEW_VERSION"
fi

VERSION=$NEW_VERSION
echo ""
echo "Preparing release for version: $VERSION"
echo ""

# Check if CHANGELOG has been updated
echo "Checking CHANGELOG.md..."
if ! grep -q "## \[$VERSION\]" CHANGELOG.md; then
    echo "Warning: CHANGELOG.md doesn't contain entry for version $VERSION"
    echo "Please update CHANGELOG.md before proceeding"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborting"
        exit 1
    fi
fi

# Check if release notes exist
RELEASE_NOTES="RELEASE_NOTES_${VERSION}.md"
if [ ! -f "$RELEASE_NOTES" ]; then
    echo "Warning: Release notes not found: $RELEASE_NOTES"
    echo "Please create release notes before proceeding"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborting"
        exit 1
    fi
fi

# Build the .deb package
echo ""
echo "Building .deb package..."
if bash scripts/build-deb.sh; then
    echo "✓ Package built successfully"
else
    echo "✗ Package build failed"
    exit 1
fi

# Generate checksums
echo ""
echo "Generating checksums..."
DEB_FILE="dist/memo-tori_${VERSION}_amd64.deb"
CHECKSUMS_FILE="dist/checksums_${VERSION}.txt"

if [ ! -f "$DEB_FILE" ]; then
    echo "Error: Package file not found: $DEB_FILE"
    exit 1
fi

cd dist
sha256sum "memo-tori_${VERSION}_amd64.deb" > "checksums_${VERSION}.txt"
md5sum "memo-tori_${VERSION}_amd64.deb" >> "checksums_${VERSION}.txt"
cd ..

echo "✓ Checksums generated: $CHECKSUMS_FILE"
echo ""
cat "$CHECKSUMS_FILE"

# Summary
echo ""
echo "=================================="
echo "Release Preparation Complete"
echo "=================================="
echo ""
echo "Version: $VERSION"
echo "Package: $DEB_FILE ($(du -h "$DEB_FILE" | cut -f1))"
echo "Checksums: $CHECKSUMS_FILE"
if [ -f "$RELEASE_NOTES" ]; then
    echo "Release Notes: $RELEASE_NOTES"
fi
echo ""

# Commit changes if VERSION was updated
if [ "$NEW_VERSION" != "$CURRENT_VERSION" ]; then
    echo "Version was updated. Don't forget to commit:"
    echo "  git add VERSION CHANGELOG.md $RELEASE_NOTES"
    echo "  git commit -m \"Release v${VERSION}\""
    echo ""
fi

# Next steps
echo "=================================="
echo "Next Steps"
echo "=================================="
echo ""
echo "1. Review the package and checksums"
echo "2. Commit any changes (if not done):"
echo "   git add VERSION CHANGELOG.md $RELEASE_NOTES"
echo "   git commit -m \"Release v${VERSION}\""
echo ""
echo "3. Create and push tag:"
echo "   git tag -a v${VERSION} -m \"Release ${VERSION}\""
echo "   git push origin v${VERSION}"
echo ""
echo "4. Create GitHub release (choose one):"
echo ""
echo "   Option A - Automatic (GitHub Actions):"
echo "   - Push the tag (step 3) and GitHub Actions will create the release"
echo ""
echo "   Option B - Manual (using GitHub CLI):"
echo "   bash scripts/create-github-release.sh"
echo ""
echo "   Option C - Manual (GitHub Web UI):"
echo "   - Go to your repository on GitHub"
echo "   - Click 'Releases' → 'Draft a new release'"
echo "   - Tag: v${VERSION}"
echo "   - Upload: $DEB_FILE and $CHECKSUMS_FILE"
echo "   - Use $RELEASE_NOTES for description"
echo ""
