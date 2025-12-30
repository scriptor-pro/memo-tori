# Release Process Documentation

This document describes the complete release process for Memo Tori, including automated and manual methods.

---

## Table of Contents

- [Quick Release (Automated)](#quick-release-automated)
- [Detailed Release Steps](#detailed-release-steps)
- [Automated Release (GitHub Actions)](#automated-release-github-actions)
- [Manual Release (GitHub CLI)](#manual-release-github-cli)
- [Manual Release (Web UI)](#manual-release-web-ui)
- [Release Checklist](#release-checklist)
- [Troubleshooting](#troubleshooting)

---

## Quick Release (Automated)

The fastest way to create a release using GitHub Actions:

```bash
# 1. Prepare the release
bash scripts/prepare-release.sh

# 2. Commit changes
git add VERSION CHANGELOG.md RELEASE_NOTES_*.md
git commit -m "Release v0.1.4"

# 3. Create and push tag
git tag -a v0.1.4 -m "Release 0.1.4"
git push origin main
git push origin v0.1.4
```

GitHub Actions will automatically:
- Build the .deb package
- Generate checksums
- Create the GitHub release
- Upload all assets

---

## Detailed Release Steps

### Step 1: Prepare the Release

Run the preparation script:

```bash
bash scripts/prepare-release.sh
```

This script will:
1. Check current version
2. Prompt for new version (if updating)
3. Verify CHANGELOG.md is updated
4. Verify release notes exist
5. Build the .deb package
6. Generate checksums

### Step 2: Update Documentation

Ensure all documentation is current:

- [ ] **VERSION** file contains new version
- [ ] **CHANGELOG.md** has entry for new version
- [ ] **RELEASE_NOTES_X.X.X.md** exists and is complete
- [ ] **README.md** references correct version
- [ ] All documentation cross-links work

### Step 3: Commit Changes

```bash
# Stage all relevant files
git add VERSION CHANGELOG.md RELEASE_NOTES_*.md README.md

# Commit with descriptive message
git commit -m "Release v0.1.4"

# Push to main branch
git push origin main
```

### Step 4: Create Git Tag

```bash
# Create annotated tag
git tag -a v0.1.4 -m "Release 0.1.4"

# Push tag to trigger automated release
git push origin v0.1.4
```

### Step 5: Verify Release

Once GitHub Actions completes (or after manual release):

1. Check the [Releases page](https://github.com/YOUR_USERNAME/memo-tori/releases)
2. Verify the release is published
3. Test download links
4. Verify checksums match

---

## Automated Release (GitHub Actions)

### How It Works

When you push a version tag (e.g., `v0.1.4`), GitHub Actions automatically:

1. **Checks out code** from the tag
2. **Sets up Python** and installs dependencies
3. **Verifies** VERSION file matches tag
4. **Builds** the .deb package
5. **Generates** SHA256 and MD5 checksums
6. **Extracts** release notes
7. **Creates** GitHub release
8. **Uploads** .deb package and checksums
9. **Stores** artifacts for 90 days

### Requirements

- GitHub repository with Actions enabled
- `.github/workflows/release.yml` workflow file
- `RELEASE_NOTES_X.X.X.md` file (or fallback to CHANGELOG)
- Version tag pushed to GitHub

### Triggering a Release

```bash
# Create tag
git tag -a v0.1.4 -m "Release 0.1.4"

# Push tag (this triggers the workflow)
git push origin v0.1.4
```

### Monitoring Progress

1. Go to your repository on GitHub
2. Click **Actions** tab
3. Find the workflow run for your tag
4. Monitor progress and check logs

### Workflow File Location

`.github/workflows/release.yml`

---

## Manual Release (GitHub CLI)

If you prefer manual control or GitHub Actions is unavailable:

### Prerequisites

Install GitHub CLI:

```bash
# Debian/Ubuntu
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh

# Authenticate
gh auth login
```

### Create Release

```bash
# Run the release script
bash scripts/create-github-release.sh
```

This script will:
1. Verify VERSION file exists
2. Verify .deb package exists
3. Verify release notes exist
4. Generate checksums
5. Create git tag
6. Push tag to remote
7. Create GitHub release with assets

### Manual Steps (Alternative)

```bash
VERSION=$(cat VERSION)
TAG="v${VERSION}"

# Create tag
git tag -a "$TAG" -m "Release $VERSION"
git push origin "$TAG"

# Create release with gh CLI
gh release create "$TAG" \
  --title "Memo Tori v${VERSION}" \
  --notes-file "RELEASE_NOTES_${VERSION}.md" \
  "dist/memo-tori_${VERSION}_amd64.deb" \
  "dist/checksums_${VERSION}.txt"
```

---

## Manual Release (Web UI)

If you prefer using GitHub's web interface:

### Step 1: Navigate to Releases

1. Go to your repository on GitHub
2. Click **Releases** (right sidebar)
3. Click **Draft a new release**

### Step 2: Create Tag

- **Tag version:** `v0.1.4`
- **Target:** `main` (or appropriate branch)

### Step 3: Add Title and Description

- **Release title:** `Memo Tori v0.1.4 "Beaufix"`
- **Description:** Copy content from `RELEASE_NOTES_0.1.4.md`

### Step 4: Upload Assets

Drag and drop or browse to upload:
- `dist/memo-tori_0.1.4_amd64.deb`
- `dist/checksums_0.1.4.txt`

### Step 5: Publish

- Uncheck "Set as a pre-release" (unless it's a beta)
- Check "Set as the latest release"
- Click **Publish release**

---

## Release Checklist

Use this checklist for each release:

### Pre-Release
- [ ] All features complete and tested
- [ ] No critical bugs outstanding
- [ ] Documentation updated
- [ ] VERSION file updated
- [ ] CHANGELOG.md updated
- [ ] RELEASE_NOTES_X.X.X.md created
- [ ] All tests passing
- [ ] No uncommitted changes

### Build & Package
- [ ] Run `bash scripts/prepare-release.sh`
- [ ] .deb package built successfully
- [ ] Package size reasonable (~3 MB)
- [ ] Checksums generated

### Version Control
- [ ] Changes committed to main branch
- [ ] Git tag created
- [ ] Tag pushed to remote

### Release Creation
- [ ] GitHub release created (automated or manual)
- [ ] Release notes attached
- [ ] Assets uploaded (.deb and checksums)
- [ ] Release published (not draft)

### Post-Release
- [ ] Release page accessible
- [ ] Download links working
- [ ] Checksums match
- [ ] Installation instructions in README current
- [ ] Announcement prepared (if applicable)

### Optional
- [ ] Update project website
- [ ] Post announcement on social media
- [ ] Notify users/contributors
- [ ] Submit to package repositories

---

## Troubleshooting

### Problem: GitHub Actions workflow fails

**Check:**
1. Workflow file syntax (`.github/workflows/release.yml`)
2. Permissions (Settings → Actions → General → Workflow permissions)
3. Secrets and tokens configured
4. Build logs for specific errors

**Solution:**
- Fix workflow file if syntax error
- Enable "Read and write permissions" for workflows
- Check Python dependencies are installable
- Verify VERSION file format

### Problem: Tag already exists

**If local:**
```bash
git tag -d v0.1.4  # Delete local tag
```

**If remote:**
```bash
git push --delete origin v0.1.4  # Delete remote tag
```

Then recreate and push again.

### Problem: Release notes not found

**Automatic workflow looks for:**
1. `RELEASE_NOTES_X.X.X.md` (preferred)
2. Falls back to CHANGELOG.md section

**Solution:**
Create `RELEASE_NOTES_0.1.4.md` with proper formatting.

### Problem: .deb package not found

**Check:**
1. `dist/` directory exists
2. `scripts/build-deb.sh` ran successfully
3. Package name matches VERSION file

**Solution:**
```bash
bash scripts/build-deb.sh
```

### Problem: Checksums mismatch

**Regenerate:**
```bash
VERSION=$(cat VERSION)
cd dist
sha256sum "memo-tori_${VERSION}_amd64.deb" > "checksums_${VERSION}.txt"
md5sum "memo-tori_${VERSION}_amd64.deb" >> "checksums_${VERSION}.txt"
```

### Problem: GitHub CLI not authenticated

**Solution:**
```bash
gh auth login
# Follow the prompts
```

### Problem: Permission denied on scripts

**Solution:**
```bash
chmod +x scripts/prepare-release.sh
chmod +x scripts/create-github-release.sh
chmod +x scripts/build-deb.sh
```

---

## Best Practices

### Semantic Versioning

Follow [SemVer](https://semver.org/):
- **MAJOR.MINOR.PATCH** (e.g., 0.1.4)
- **MAJOR:** Breaking changes
- **MINOR:** New features (backward compatible)
- **PATCH:** Bug fixes (backward compatible)

### Release Cadence

- **Patch releases:** As needed for bug fixes
- **Minor releases:** Every 1-2 months for new features
- **Major releases:** When introducing breaking changes

### Release Notes Quality

Good release notes include:
- What's new (features)
- What's improved
- What's fixed (bugs)
- Breaking changes (if any)
- Upgrade instructions
- Known issues

### Testing Before Release

1. Build and install the .deb package locally
2. Test all major features
3. Verify language switching (EN/FR)
4. Test keyboard shortcuts
5. Check documentation links

---

## Scripts Overview

### `scripts/prepare-release.sh`

**Purpose:** Prepares everything for a release
**Usage:** `bash scripts/prepare-release.sh`
**What it does:**
- Prompts for version
- Validates CHANGELOG and release notes
- Builds .deb package
- Generates checksums
- Shows next steps

### `scripts/create-github-release.sh`

**Purpose:** Creates GitHub release using CLI
**Usage:** `bash scripts/create-github-release.sh`
**Requirements:** GitHub CLI (`gh`)
**What it does:**
- Verifies prerequisites
- Creates git tag
- Pushes tag
- Creates GitHub release
- Uploads assets

### `.github/workflows/release.yml`

**Purpose:** Automates release on tag push
**Trigger:** Push of `v*` tag
**What it does:**
- Builds package
- Generates checksums
- Creates release
- Uploads assets

---

## Example: Complete Release Process

Here's a complete example of releasing v0.1.5:

```bash
# 1. Update version
echo "0.1.5" > VERSION

# 2. Update CHANGELOG.md
# (edit manually)

# 3. Create release notes
# (create RELEASE_NOTES_0.1.5.md)

# 4. Prepare release
bash scripts/prepare-release.sh

# 5. Commit
git add VERSION CHANGELOG.md RELEASE_NOTES_0.1.5.md
git commit -m "Release v0.1.5"
git push origin main

# 6. Tag and push (triggers GitHub Actions)
git tag -a v0.1.5 -m "Release 0.1.5"
git push origin v0.1.5

# 7. Wait for GitHub Actions to complete
# 8. Verify release at: https://github.com/YOUR_USERNAME/memo-tori/releases
```

---

**Last updated:** 2025-12-29
