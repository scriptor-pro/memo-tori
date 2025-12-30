#!/bin/bash
# Create a GitHub release for Memo Tori
# Requires: gh (GitHub CLI) - https://cli.github.com/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$ROOT_DIR"

# Read version
if [ ! -f "VERSION" ]; then
    echo "Error: VERSION file not found"
    exit 1
fi

VERSION=$(cat VERSION | tr -d '[:space:]')
TAG="v${VERSION}"

echo "=================================="
echo "GitHub Release Creator"
echo "=================================="
echo ""
echo "Version: $VERSION"
echo "Tag: $TAG"
echo ""

# Check if gh is installed
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed."
    echo "Install from: https://cli.github.com/"
    echo ""
    echo "On Debian/Ubuntu:"
    echo "  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg"
    echo "  echo \"deb [arch=\$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main\" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null"
    echo "  sudo apt update"
    echo "  sudo apt install gh"
    exit 1
fi

# Check if user is authenticated
if ! gh auth status &> /dev/null; then
    echo "Error: Not authenticated with GitHub CLI"
    echo "Run: gh auth login"
    exit 1
fi

# Check if .deb package exists
DEB_FILE="dist/memo-tori_${VERSION}_amd64.deb"
if [ ! -f "$DEB_FILE" ]; then
    echo "Error: Package file not found: $DEB_FILE"
    echo "Build it first with: bash scripts/build-deb.sh"
    exit 1
fi

# Check if release notes exist
RELEASE_NOTES="RELEASE_NOTES_${VERSION}.md"
if [ ! -f "$RELEASE_NOTES" ]; then
    echo "Error: Release notes not found: $RELEASE_NOTES"
    exit 1
fi

# Generate checksums
CHECKSUMS_FILE="dist/checksums_${VERSION}.txt"
echo "Generating checksums..."
cd dist
sha256sum "memo-tori_${VERSION}_amd64.deb" > "../${CHECKSUMS_FILE}"
md5sum "memo-tori_${VERSION}_amd64.deb" >> "../${CHECKSUMS_FILE}"
cd ..

echo "Checksums saved to: $CHECKSUMS_FILE"
echo ""
cat "$CHECKSUMS_FILE"
echo ""

# Check if tag exists
if git rev-parse "$TAG" >/dev/null 2>&1; then
    echo "Tag $TAG already exists locally"
    read -p "Do you want to delete it and recreate? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git tag -d "$TAG"
        echo "Tag deleted locally"
    else
        echo "Aborting"
        exit 1
    fi
fi

# Create git tag
echo "Creating git tag: $TAG"
git tag -a "$TAG" -m "Release $VERSION"

# Push tag to remote
echo "Pushing tag to remote..."
git push origin "$TAG" || {
    echo "Warning: Could not push tag. You may need to push it manually:"
    echo "  git push origin $TAG"
}

# Extract release title from release notes
RELEASE_TITLE=$(grep -m 1 "^# " "$RELEASE_NOTES" | sed 's/^# //')
if [ -z "$RELEASE_TITLE" ]; then
    RELEASE_TITLE="Memo Tori $VERSION"
fi

echo ""
echo "=================================="
echo "Creating GitHub Release"
echo "=================================="
echo "Title: $RELEASE_TITLE"
echo "Tag: $TAG"
echo "Assets:"
echo "  - $DEB_FILE"
echo "  - $CHECKSUMS_FILE"
echo ""

# Create GitHub release
gh release create "$TAG" \
    --title "$RELEASE_TITLE" \
    --notes-file "$RELEASE_NOTES" \
    "$DEB_FILE" \
    "$CHECKSUMS_FILE"

if [ $? -eq 0 ]; then
    echo ""
    echo "=================================="
    echo "✅ Release created successfully!"
    echo "=================================="
    echo ""
    echo "View your release at:"
    gh release view "$TAG" --web
else
    echo ""
    echo "❌ Failed to create release"
    exit 1
fi
