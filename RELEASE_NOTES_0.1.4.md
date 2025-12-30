# Memo Tori v0.1.4 "Beaufix" - Release Notes

**Release Date:** December 29, 2025  
**Codename:** Beaufix (Beautiful + Fix)

---

## 🎉 What's New

### 🌍 Internationalization (i18n)

Memo Tori now speaks **English and French**!

- **Automatic language detection** from your system locale
- **Manual override** with `MEMO_TORI_LANG` environment variable
- **Complete UI translation** - all 12 UI strings translated
- **Language-specific launchers** - `memo-tori-en.sh` and `memo-tori-fr.sh`
- **Separate desktop entries** for each language

#### How to Use:

```bash
# Auto-detect from system (default)
memo-tori

# Force English
MEMO_TORI_LANG=en memo-tori

# Force French
MEMO_TORI_LANG=fr memo-tori
```

Supported locales:
- English: en_US, en_GB, en_CA, and all en_* variants
- French: fr_FR, fr_BE, fr_CA, and all fr_* variants
- Other locales default to English

---

### ⌨️ Universal Keyboard Shortcuts

One command to set up keyboard shortcuts across all major desktop environments!

- **Automatic setup script**: `scripts/setup-keyboard-shortcut.sh`
- **Default shortcut**: Super+M (Windows/Command key + M)
- **7 desktop environment families** supported (11+ variants)

#### Supported Desktop Environments:

| Desktop Environment | Method |
|---------------------|--------|
| XFCE | xfconf-query |
| GNOME / Unity / Budgie | gsettings |
| Cinnamon | gsettings (Cinnamon schema) |
| MATE | gsettings (MATE schema) |
| KDE Plasma | kwriteconfig5 |
| i3 / Sway | Config file editing |
| LXDE / LXQt | Openbox XML |

#### Quick Setup:

```bash
bash scripts/setup-keyboard-shortcut.sh
```

Then press **Super+M** to launch Memo Tori instantly!

---

### 🏷️ Version Display in Window Title

The window title now displays the current version number for easy identification.

**Window title format:** `Memo Tori 0.1.4`

This helps with:
- Quick version identification
- Bug reporting and support
- Development and testing

---

### 📚 Comprehensive Documentation

Five new comprehensive guides covering all aspects of Memo Tori:

1. **[Installation Guide](docs/INSTALLATION_GUIDE.md)** - Complete setup instructions
2. **[Keyboard Shortcuts Guide](docs/KEYBOARD_SHORTCUTS.md)** - Detailed DE-specific setup
3. **[Localization Guide](docs/LOCALIZATION.md)** - Language configuration
4. **[Quick Reference](docs/QUICK_REFERENCE.md)** - One-page cheat sheet
5. **[Documentation Index](docs/README.md)** - Navigation hub

Total documentation: **40KB** across 5 guides

---

## 📦 Installation

### Debian/Ubuntu (.deb package)

```bash
# Download the package
wget https://[your-repo]/releases/memo-tori_0.1.4_amd64.deb

# Install
sudo dpkg -i memo-tori_0.1.4_amd64.deb
sudo apt-get install -f  # Fix any dependencies

# Launch
memo-tori
```

### From Source

```bash
# Clone or download
cd /path/to/memo-tori

# Install system dependencies
sudo apt install python3-venv python3-pip python3-gi gir1.2-gtk-3.0 gir1.2-webkit2-4.0

# Set up Python environment
python3 -m venv --system-site-packages .venv
source .venv/bin/activate
pip install -r requirements.txt

# Run
python3 memo-tori.py
```

---

## 🔄 Upgrading from v0.1.3

Your data is **fully compatible** and will be preserved during the upgrade.

### Method 1: .deb Package

```bash
# Remove old version
sudo apt remove memo-tori

# Install new version
sudo dpkg -i memo-tori_0.1.4_amd64.deb

# Your data remains at: ~/.local/share/memo-tori/ideas.txt
```

### Method 2: From Source

```bash
cd /path/to/memo-tori
git pull  # or download new version
source .venv/bin/activate
pip install --upgrade -r requirements.txt
```

---

## 🌟 Features

### Core Functionality
- ✅ Single text field (up to 5000 characters)
- ✅ Save ideas to local file
- ✅ View full list of ideas (newest first)
- ✅ Delete ideas with confirmation
- ✅ Plain text storage (no database)

### New in v0.1.4
- ✅ **English and French UI**
- ✅ **Automatic language detection**
- ✅ **Universal keyboard shortcuts**
- ✅ **Version display in window title**
- ✅ **Comprehensive documentation**

### Platform Support
- ✅ Linux (Debian 11+, Ubuntu 20.04+, Fedora 36+, Arch)
- ✅ Windows (via pywebview with WebView2)
- ✅ All major desktop environments

---

## 🐛 Bug Fixes

This release focuses on new features. No specific bug fixes were required from v0.1.3.

---

## 📝 Technical Details

### Package Information
- **Version:** 0.1.4
- **Package Size:** 3.1 MB (includes Python dependencies)
- **Architecture:** amd64
- **Dependencies:** python3, python3-gi, gir1.2-gtk-3.0, gir1.2-webkit2-4.0

### New Files
- `i18n.py` - Localization module (3.4 KB)
- `VERSION` - Version file (6 bytes)
- `memo-tori-en.sh` - English launcher
- `memo-tori-fr.sh` - French launcher
- `memo-tori-en.desktop` - English desktop entry
- `memo-tori-fr.desktop` - French desktop entry
- `scripts/setup-keyboard-shortcut.sh` - Keyboard shortcut setup (15 KB)
- `docs/` - 5 comprehensive documentation files (40 KB)

### Translation Coverage
- **Total translation keys:** 12
- **Coverage:** 100% for English and French
- **Extensible:** Easy to add more languages

---

## 🔮 Looking Ahead

### Planned for v0.1.5
- Additional language support (Spanish, German, Italian)
- Enhanced keyboard shortcut management UI
- Export/import functionality
- Search capabilities (optional)
- UI/UX refinements

### Future Considerations
- Mobile app versions
- Cloud sync (optional plugin)
- Tags and categories (keeping it simple)
- Dark mode

---

## 🙏 Acknowledgments

- **Development:** Rovo Dev AI Assistant
- **Testing:** MX Linux 23 / Debian 12 (XFCE, fr_BE locale)
- **Community:** Thank you to all early adopters and testers!

---

## 📞 Support & Feedback

### Documentation
- Main README: [README.md](README.md)
- Full Documentation: [docs/README.md](docs/README.md)
- CHANGELOG: [CHANGELOG.md](CHANGELOG.md)

### Reporting Issues
When reporting issues, please include:
1. Version number (shown in window title)
2. Operating system and desktop environment
3. Language setting (if relevant)
4. Steps to reproduce
5. Expected vs actual behavior

### Language
- System locale detected from your OS
- Override with: `MEMO_TORI_LANG=en` or `MEMO_TORI_LANG=fr`

---

## 📄 License

MIT License - See [LICENSE](LICENSE) file for details.

---

## 🎊 Conclusion

Memo Tori v0.1.4 "Beaufix" brings powerful new features while maintaining the simplicity and speed you expect. With full bilingual support and universal keyboard shortcuts, capturing your ideas has never been easier!

**Download now and start capturing ideas in your language!**

---

**Release Checksums:**

```
# SHA256
sha256sum memo-tori_0.1.4_amd64.deb
# [Will be generated]

# MD5
md5sum memo-tori_0.1.4_amd64.deb
# [Will be generated]
```

---

**Released by:** Memo Tori Team  
**Date:** December 29, 2025  
**Version:** 0.1.4 "Beaufix"
