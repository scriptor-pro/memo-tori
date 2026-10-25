# Memo Tori - Quick Start Guide

Get up and running with Memo Tori in **2 minutes**!

---

## 📦 Step 1: Download

**Latest version:** v0.2.0

### Option A: .deb Package (Recommended for Debian/Ubuntu)

Download from GitHub Releases: https://github.com/scriptor-pro/memo-tori/releases/latest

File: `memo-tori_0.2.0_amd64.deb`

**Compatible with:**
- Debian 11+
- Ubuntu 20.04+
- Linux Mint 20+
- MX Linux 23+
- Pop!_OS 20.04+

### Option B: From Source

```bash
git clone [your-repo-url]
cd memo-tori
```

---

## 🔧 Step 2: Install

### If using .deb package:

```bash
sudo dpkg -i memo-tori_0.2.0_amd64.deb
sudo apt-get install -f  # Fix any missing dependencies
```

### If using source:

```bash
# Install system dependencies
sudo apt install python3-venv python3-pip python3-gi gir1.2-gtk-3.0 gir1.2-webkit2-4.0

# Set up Python environment
python3 -m venv --system-site-packages .venv
source .venv/bin/activate
pip install -r requirements.txt
```

---

## ⌨️ Step 3: Set Up Keyboard Shortcut (Optional but Recommended)

**From source directory:**
```bash
bash scripts/setup-keyboard-shortcut.sh
```

This will configure **Super+M** to launch Memo Tori instantly!

**Supported desktop environments:**
- XFCE, GNOME, KDE, MATE, Cinnamon, i3, Sway, LXDE, LXQt

---

## 🚀 Step 4: Launch!

### If installed via .deb:
```bash
memo-tori
```

### If running from source:
```bash
python3 memo-tori.py
```

### Or use the keyboard shortcut:
Press **Super+M** (Windows key + M)

### Or from app launcher:
Search for "Memo Tori" in your application menu

---

## 🌐 Step 5: Choose Your Language

Memo Tori auto-detects your system language (English or French).

**To force a specific language:**

**English:**
```bash
MEMO_TORI_LANG=en memo-tori
```

**French:**
```bash
MEMO_TORI_LANG=fr memo-tori
```

---

## ✅ You're Ready!

The window title should show: **"Memo Tori 0.2.0"**

### Now you can:

1. **Type your idea** in the text field (up to 5000 characters)
2. **Click "Save this idea"** (or "Sauvegarder cette idée" in French)
3. **View your ideas** by clicking "Ideas list" (or "Liste des idées")
4. **Delete ideas** by checking the box next to them

### Data location:
- Linux: `~/.local/share/memo-tori/ideas.txt`
- Windows: `%APPDATA%\memo-tori\ideas.txt`

---

## 📚 Need More Help?

- **Full Documentation:** [docs/README.md](docs/README.md)
- **Installation Guide:** [docs/INSTALLATION_GUIDE.md](docs/INSTALLATION_GUIDE.md)
- **Keyboard Shortcuts:** [docs/KEYBOARD_SHORTCUTS.md](docs/KEYBOARD_SHORTCUTS.md)
- **Language Setup:** [docs/LOCALIZATION.md](docs/LOCALIZATION.md)
- **Release Notes:** [RELEASE_NOTES_0.2.0.md](RELEASE_NOTES_0.2.0.md)
- **Changelog:** [CHANGELOG.md](CHANGELOG.md)

---

## 🎯 Quick Tips

### Keyboard Shortcuts
- **Super+M** - Launch Memo Tori (after setup)
- **Tab** - Navigate between fields
- **Enter** (in textarea) - New line
- **Ctrl+Enter** - Could be mapped to save (in future)

### Language Switching
Set permanently in `~/.bashrc`:
```bash
echo 'export MEMO_TORI_LANG=en' >> ~/.bashrc
source ~/.bashrc
```

### Multiple Instances
You can run multiple instances, but they share the same data file.

### Backup Your Ideas
Simply copy the file:
```bash
cp ~/.local/share/memo-tori/ideas.txt ~/backup/ideas-backup.txt
```

---

## 🐛 Troubleshooting

### Issue: App won't start

**Check dependencies:**
```bash
sudo apt install python3-gi gir1.2-gtk-3.0 gir1.2-webkit2-4.0
```

**From source, check venv:**
```bash
source .venv/bin/activate
pip install -r requirements.txt
```

### Issue: Keyboard shortcut doesn't work

**Manual setup:** See [Keyboard Shortcuts Guide](docs/KEYBOARD_SHORTCUTS.md#manual-configuration)

**Verify setup:**
```bash
# For XFCE:
xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/<Super>m"
```

### Issue: Wrong language

**Force your language:**
```bash
MEMO_TORI_LANG=en memo-tori  # or MEMO_TORI_LANG=fr
```

**Check system locale:**
```bash
locale
```

---

## ✨ What's New in v0.2.0?

- ✍️ **Better writing feel** (IBM Plex Mono for the capture field)
- 🧩 **Modern UI typography** (Inter for the interface)
- 📦 **Improved packaging** (AppImage on tag releases, macOS DMG, Windows installer on Releases)

See [RELEASE_NOTES_0.2.0.md](RELEASE_NOTES_0.2.0.md) for full details.

---

## 🎊 Success!

You're now ready to capture ideas instantly with Memo Tori!

Press **Super+M** anytime to jot down your thoughts. Simple, fast, private.

**Happy idea capturing!** 💡
