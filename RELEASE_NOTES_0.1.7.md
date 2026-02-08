# Memo Tori v0.1.7 - Release Notes

This release focuses on packaging and distribution improvements across platforms, plus a UI view-switching fix.

## Highlights

- Linux tag releases now include an AppImage in GitHub Releases (alongside the .deb).
- Windows installer workflow now attaches the generated setup executable to the GitHub Release.
- macOS packaging now produces a DMG and uploads it to the GitHub Release.

## Changes

### Packaging / Release

- GitHub Actions: build AppImage on tag releases (`.github/workflows/release.yml`).
- GitHub Actions: publish Windows installer to releases (`.github/workflows/windows-installer.yml`).
- GitHub Actions: build and publish macOS DMG (`.github/workflows/macos-package.yml`).
- Manual release script now supports optional assets (AppImage, Arch, RPM) and generates checksums for everything it uploads (`scripts/create-github-release.sh`).
- Added RPM build script and spec template (`scripts/build-rpm.sh`, `packaging/rpm/memo-tori.spec.in`).

### App / UI

- Fixed panel switching behavior so hidden panels no longer reserve layout space; added a light entrance animation (`web/style.css`, `web/app.js`).
- Improved resource resolution in frozen builds (PyInstaller): `VERSION` and `web/index.html` are loaded correctly when bundled (`memo-tori.py`).

## Downloads

- https://github.com/scriptor-pro/memo-tori/releases/tag/v0.1.7
