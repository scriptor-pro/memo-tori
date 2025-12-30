# Memo Tori Documentation

Welcome to the Memo Tori documentation! This directory contains guides and reference materials for using Memo Tori effectively.

## 📚 Documentation Index

### Getting Started

- **[Installation Guide](INSTALLATION_GUIDE.md)** - Complete installation and setup guide. Covers:
  - System requirements and prerequisites
  - Installation methods (source, .deb, Windows)
  - Desktop integration setup
  - Post-installation verification
  - Updating and uninstallation
  - Troubleshooting installation issues

### Keyboard Shortcuts

- **[Keyboard Shortcuts Guide](KEYBOARD_SHORTCUTS.md)** - Complete guide for setting up keyboard shortcuts across different Linux desktop environments. Includes:
  - Automatic setup instructions
  - Supported desktop environments (XFCE, GNOME, KDE, MATE, Cinnamon, i3/Sway, LXDE/LXQt)
  - Troubleshooting common issues
  - Manual configuration for each DE
  - Advanced topics and customization

- **[Quick Reference](QUICK_REFERENCE.md)** - One-page cheat sheet for quick setup and troubleshooting. Perfect for:
  - Fast setup (30-second guide)
  - Command reference
  - Quick troubleshooting
  - At-a-glance DE compatibility

### Localization

- **[Localization Guide](LOCALIZATION.md)** - Language support documentation. Covers:
  - Supported languages (English, French)
  - Language detection and selection
  - Using language-specific launchers
  - Environment variable configuration
  - Adding new languages
  - Troubleshooting language issues

## 🚀 Getting Started

### First Time Setup

1. **Install dependencies** (see [main README](../README.md#requirements-mx-linux-23--debian-12))
2. **Set up the application** (see [main README](../README.md#install))
3. **Configure keyboard shortcut**:
   ```bash
   cd /path/to/memo-tori
   bash scripts/setup-keyboard-shortcut.sh
   ```
4. **Start using**: Press **Super+M** to launch Memo Tori!

## 🎯 Quick Links

### For Users

- [Main README](../README.md) - Project overview and installation
- [Keyboard Shortcuts Guide](KEYBOARD_SHORTCUTS.md) - Complete keyboard shortcut documentation
- [Quick Reference](QUICK_REFERENCE.md) - One-page reference card

### For Developers

- [Project Structure](../README.md#project-structure) - Codebase organization
- [Desktop Integration](../README.md#desktop-integration) - .desktop file setup
- [Packaging](../packaging/) - Distribution package creation
- [Scripts](../scripts/) - Build and setup scripts

## 🆘 Getting Help

### Common Tasks

| Task | Documentation |
|------|--------------|
| Installing Memo Tori | [Installation Guide](INSTALLATION_GUIDE.md) |
| Setting up keyboard shortcut | [Keyboard Shortcuts Guide](KEYBOARD_SHORTCUTS.md#quick-setup) |
| Changing language (EN/FR) | [Localization Guide](LOCALIZATION.md) |
| Troubleshooting installation | [Installation Guide - Troubleshooting](INSTALLATION_GUIDE.md#troubleshooting-installation-issues) |
| Troubleshooting shortcut issues | [Keyboard Shortcuts Guide - Troubleshooting](KEYBOARD_SHORTCUTS.md#troubleshooting) |
| Troubleshooting language issues | [Localization Guide - Troubleshooting](LOCALIZATION.md#troubleshooting) |
| Manual DE configuration | [Manual Configuration](KEYBOARD_SHORTCUTS.md#manual-configuration) |
| Changing the default shortcut | [Advanced Topics](KEYBOARD_SHORTCUTS.md#changing-the-shortcut-key) |
| Updating Memo Tori | [Installation Guide - Updating](INSTALLATION_GUIDE.md#updating-memo-tori) |
| Uninstalling Memo Tori | [Installation Guide - Uninstallation](INSTALLATION_GUIDE.md#uninstallation) |
| Building packages | [Packaging directories](../packaging/) |

### Quick Answers

**Q: What keyboard shortcut does Memo Tori use?**  
A: **Super+M** (Windows key + M) by default.

**Q: Which desktop environments are supported?**  
A: XFCE, GNOME, Unity, Budgie, Cinnamon, MATE, KDE Plasma, i3, Sway, LXDE, and LXQt.

**Q: Can I use a different keyboard shortcut?**  
A: Yes! See the [advanced topics](KEYBOARD_SHORTCUTS.md#changing-the-shortcut-key) section.

**Q: The automatic setup didn't work. What now?**  
A: Check the [troubleshooting guide](KEYBOARD_SHORTCUTS.md#troubleshooting) or use the [manual setup instructions](KEYBOARD_SHORTCUTS.md#manual-configuration).

**Q: Where is my data stored?**  
A: See the [data format section](../README.md#data-format) in the main README.

**Q: Can I use Memo Tori in English or French?**  
A: Yes! Both languages are supported. See the [Localization Guide](LOCALIZATION.md) for details.

**Q: How do I change the language?**  
A: The app auto-detects from your system locale. To force a language, set `MEMO_TORI_LANG=en` or `MEMO_TORI_LANG=fr`. See [Localization Guide](LOCALIZATION.md).

## 📖 Documentation Conventions

### Symbols Used

- ✅ - Supported/Working feature
- ⚠️ - Warning or important note
- 🔧 - Configuration or setup required
- 🐛 - Troubleshooting or bug fix
- 💡 - Tip or best practice
- 📚 - Additional documentation available

### Path Placeholders

- `/path/to/memo-tori` - Replace with your actual installation directory
- `~/.config/...` - User configuration directory (expands to `/home/username/.config/...`)
- `$HOME/...` - User home directory

### Command Examples

Commands shown with `$` prefix are meant to be run in a terminal:
```bash
$ cd /path/to/memo-tori
```

Commands without prefix are configuration snippets or code examples.

## 🤝 Contributing

If you find issues with the documentation or have suggestions for improvements:

1. Check if the issue is already known
2. Provide clear examples and context
3. Suggest specific improvements
4. Test any proposed changes on your system

## 📋 Documentation Checklist

When updating documentation, ensure:

- [ ] All commands are tested and working
- [ ] File paths are correct and consistent
- [ ] Links to other documents work
- [ ] Examples use realistic paths and values
- [ ] Version-specific information is noted
- [ ] Breaking changes are highlighted
- [ ] Screenshots/examples are up to date (if any)

## 📝 License

All documentation is released under the same license as Memo Tori (MIT License).

---

**Last updated**: 2025-12-29  
**Documentation version**: 1.0
