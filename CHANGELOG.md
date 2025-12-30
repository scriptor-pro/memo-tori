# Changelog

All notable changes to Memo Tori will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.4] - 2025-12-29 "Beaufix"

**Codename:** Beaufix (Beautiful + Fix)  
**Release Focus:** Internationalization and User Experience

This major feature release brings full bilingual support (English/French), universal keyboard shortcuts across all desktop environments, and comprehensive documentation.

### 🌍 Internationalization

#### Added
- **Full English and French UI support**
  - 12 translation keys covering all UI elements
  - Automatic language detection from system locale
  - Environment variable override (`MEMO_TORI_LANG=en` or `MEMO_TORI_LANG=fr`)
  - Localization module (`i18n.py`)
  - Language-specific launchers: `memo-tori-en.sh`, `memo-tori-fr.sh`
  - Language-specific desktop entries: `memo-tori-en.desktop`, `memo-tori-fr.desktop`
  - Fallback to English for unsupported locales
  - Extensible architecture for future languages

#### Supported Locales
- **English:** en_US, en_GB, en_CA, and all en_* variants
- **French:** fr_FR, fr_BE, fr_CA, and all fr_* variants
- **Default:** English (for other locales)

### ⌨️ Universal Keyboard Shortcuts

#### Added
- **Automatic keyboard shortcut setup** (`scripts/setup-keyboard-shortcut.sh`)
  - One-command setup across all supported desktop environments
  - Auto-detects your desktop environment
  - Configures Super+M as the default launch shortcut
  - Provides fallback instructions for unsupported DEs

#### Desktop Environment Support (7 families, 11+ variants)
- **XFCE** - Using xfconf-query
- **GNOME / Unity / Budgie** - Using gsettings
- **Cinnamon** - Using gsettings (Cinnamon schema)
- **MATE** - Using gsettings (MATE schema)
- **KDE Plasma** - Using kwriteconfig5
- **i3 / Sway** - Config file editing
- **LXDE / LXQt** - Openbox XML configuration

#### Features
- Tested and verified on XFCE (fr_BE locale)
- Comprehensive troubleshooting for each DE
- Manual configuration guides included
- Safe error handling with clear messages

### 🏷️ Version Display

#### Added
- **Window title now displays version number**
  - Format: "Memo Tori 0.1.4"
  - Reads from VERSION file automatically
  - Helps with version identification and bug reporting
  - Fallback to "0.0.0" if VERSION file missing

### 📚 Documentation

#### Added
- **Installation Guide** (`docs/INSTALLATION_GUIDE.md`, 8.7 KB)
  - Complete step-by-step installation instructions
  - Multiple installation methods (.deb, source, Windows)
  - Post-installation verification checklist
  - Updating and uninstallation procedures
  - Troubleshooting installation issues

- **Keyboard Shortcuts Guide** (`docs/KEYBOARD_SHORTCUTS.md`, 12 KB)
  - Comprehensive guide for all desktop environments
  - Automatic and manual setup instructions
  - Detailed troubleshooting section
  - Advanced customization topics

- **Localization Guide** (`docs/LOCALIZATION.md`, 6.5 KB)
  - Complete language configuration documentation
  - Using language-specific launchers
  - Environment variable setup
  - Adding new languages guide
  - Troubleshooting language issues

- **Quick Reference** (`docs/QUICK_REFERENCE.md`, 2.8 KB)
  - One-page cheat sheet
  - Fast setup guide (30 seconds)
  - Quick troubleshooting reference
  - DE compatibility table

- **Documentation Index** (`docs/README.md`, 6.1 KB)
  - Navigation hub for all documentation
  - Getting started guide
  - Common tasks reference
  - FAQ section

**Total Documentation:** 40 KB across 5 comprehensive guides

### 🔧 Technical Changes

#### Modified Files
- **memo-tori.py**
  - Import i18n module for localization
  - Read VERSION file at startup
  - Detect language and load appropriate translations
  - Enhanced API with `get_translations()` method
  - Window title includes version number

- **web/index.html**
  - Added data-i18n attributes for translation support
  - Changed default content to English
  - Updated HTML lang attribute (dynamically set)

- **web/app.js**
  - Dynamic translation loading from backend
  - Apply translations to all UI elements on startup
  - Translate placeholders, buttons, messages dynamically
  - Fallback to English translations on error

- **README.md**
  - Added language options section
  - Updated with comprehensive documentation links
  - Streamlined keyboard shortcut section
  - Added "Window title displays current version" feature

- **scripts/build-deb.sh**
  - Include i18n.py in package
  - Include VERSION file in package

### 📦 Package Updates

#### .deb Package (v0.1.4)
- Package size: 3.1 MB (includes Python dependencies)
- Architecture: amd64
- All new files included (i18n.py, VERSION, launchers, docs)
- Compatible with Debian 11+, Ubuntu 20.04+, MX Linux 23

### 🎯 User Experience Improvements

- **Easier to launch:** Press Super+M from anywhere
- **Multilingual:** Use in your preferred language
- **Version clarity:** See version at a glance in window title
- **Better documentation:** Find answers quickly in comprehensive guides
- **Cross-DE compatibility:** Works seamlessly on any desktop environment

### ⚙️ Developer Improvements

- Single source of truth for version (VERSION file)
- Extensible i18n architecture
- Comprehensive documentation for contributors
- Automated keyboard shortcut setup reduces support burden

### 📊 Statistics

- **New Files Created:** 11
- **Files Modified:** 6
- **Documentation Added:** 40 KB (5 guides)
- **Translation Keys:** 12 (100% EN/FR coverage)
- **Lines of Code Added:** ~500+
- **Desktop Environments:** 7 families (11+ variants)
- **Languages Supported:** 2 (English, French)

## [0.1.3] - 2025-12-29

### Fixed
- Fixed invalid DOCTYPE declaration in web/index.html
- Improved development desktop file with proper icon path and labeling

### Changed
- Updated button text from "Consulter" to "Liste des idées" for clarity
- Refined color scheme (background and accent colors)
- Updated font family stack for better cross-platform consistency

### Added
- Added .gitignore to exclude build artifacts and development files

## [0.1.2] - 2024-12-27

### Added
- Debian package (.deb) build for version 0.1.2
- Windows installer support

## [0.1.1] - 2024-12-26

### Changed
- Accessibility improvements: updated color scheme for better contrast

## [0.1.0] - 2024-12-26

### Added
- Initial public release
- Core functionality: capture and store ideas locally
- Plain text storage with `---` separator
- Linux (Debian-based) support
- Windows support via pywebview
- Build scripts for .deb packages
- GitHub Actions workflow for Windows installer
- MIT License
- Comprehensive README with installation instructions

