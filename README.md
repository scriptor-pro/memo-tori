# Memo Tori

**Version:** 0.1.4 "Beaufix" | **Released:** December 29, 2025

Memo Tori is a tiny desktop app to capture a single idea and store it locally as plain text.

**Available in English and French** | **Universal keyboard shortcuts** | **Cross-platform**

## 📥 Download

**Latest Release:** v0.1.4 "Beaufix" (December 29, 2025)

- **[memo-tori_0.1.4_amd64.deb](dist/memo-tori_0.1.4_amd64.deb)** - Debian/Ubuntu package (3.1 MB)
- **[Release Notes](RELEASE_NOTES_0.1.4.md)** - What's new in v0.1.4
- **[Quick Start Guide](QUICKSTART.md)** - Get started in 2 minutes

**System Requirements:**
- Debian 11+, Ubuntu 20.04+, or compatible Linux distribution
- Python 3.10+, GTK3, WebKit2

## 🚀 Quick Start

**1. Install:**
```bash
sudo dpkg -i memo-tori_0.1.4_amd64.deb
sudo apt-get install -f
```

**2. Set up keyboard shortcut (optional):**
```bash
bash scripts/setup-keyboard-shortcut.sh
```

**3. Launch:** Press **Super+M** or search for "Memo Tori" in your app launcher!

**Complete guide:** [QUICKSTART.md](QUICKSTART.md) | [Full documentation](docs/README.md) | [Installation Guide](docs/INSTALLATION_GUIDE.md)

---

## 🌟 Highlights

- 🌍 **Bilingual** - Full English and French support with automatic detection
- ⌨️ **Quick Launch** - Press Super+M from anywhere (auto-configurable)
- 🚀 **Simple** - One text field, save, view list, delete
- 🔒 **Private** - Everything stored locally as plain text
- 🖥️ **Cross-Platform** - Linux (7+ DEs) and Windows support

## What it does

- One text field (up to 5000 characters)
- Save the idea to a local file
- View the full list of ideas (newest first)
- Delete ideas with a confirmation
- Available in English and French
- Window title displays current version
- Keyboard shortcut (Super+M) for instant access

No editing, no search, no metadata, no sync.

## Tech

- Python + pywebview (GTK on Linux)
- Embedded HTML/CSS/JS (no frontend framework)
- Storage: UTF-8 plain text with `---` separators

## Requirements (MX Linux 23 / Debian 12)

System packages:

```bash
sudo apt update
sudo apt install -y python3-venv python3-pip python3-gi gir1.2-gtk-3.0 gir1.2-webkit2-4.0
```

## Linux compatibility

Memo Tori targets Linux distributions that provide GTK3 + WebKit2 + Python 3.

Known compatible families:

- Debian 11/12 and derivatives (MX Linux 23, Ubuntu 20.04+, Linux Mint)
- Fedora 36+
- Arch / Manjaro

Package hints:

Debian / Ubuntu / Mint / MX:

```bash
sudo apt install -y python3-venv python3-pip python3-gi gir1.2-gtk-3.0 gir1.2-webkit2-4.0
```

Note: on Debian/MX, use the system Python 3.11 for the venv if your default `python3` points to a newer version:

```bash
/usr/bin/python3.11 -m venv --system-site-packages .venv
```

Fedora:

```bash
sudo dnf install -y python3 python3-pip python3-gobject gtk3 webkit2gtk4.0
```

Arch / Manjaro:

```bash
sudo pacman -S python python-pip python-gobject gtk3 webkit2gtk
```

## Windows (installer)

Prerequisites on Windows:

- Python 3.10+ installed and on PATH
- WebView2 Runtime installed (usually preinstalled on Windows 11)
- Inno Setup installed (so `iscc.exe` is on PATH)

Build the installer from PowerShell:

```powershell
cd C:\path\to\memo-tori
.\scripts\build-windows-installer.ps1
```

Output:

```
dist\memo-tori-0.1.0-setup.exe
```

## Versioning

The version is stored in the `VERSION` file at the project root. Set the `VERSION` environment variable to override it for a single build.

## Install

```bash
cd /path/to/memo-tori
python3 -m venv --system-site-packages .venv
. .venv/bin/activate
pip install -r requirements.txt
```

If your system `python3` is not Debian's 3.11, use it explicitly:

```bash
/usr/bin/python3.11 -m venv --system-site-packages .venv
```

## Run

```bash
cd /home/Baudouin/Documents/Projets/Memo-Tori
. .venv/bin/activate
python3 memo-tori.py
```

**Language options:**
- Auto-detect from system: `python3 memo-tori.py` (default)
- Force English: `MEMO_TORI_LANG=en python3 memo-tori.py`
- Force French: `MEMO_TORI_LANG=fr python3 memo-tori.py`

See [Localization Guide](docs/LOCALIZATION.md) for more details.

## Desktop integration

To add Memo Tori to your app launcher:

```bash
mkdir -p ~/.local/share/applications
cp /home/Baudouin/Documents/Projets/Memo-Tori/memo-tori.desktop ~/.local/share/applications/
```

## Keyboard shortcut (Linux)

**Quick setup (30 seconds):**

Run the setup script to automatically configure **Super+M** as the keyboard shortcut:

```bash
cd /path/to/memo-tori
bash scripts/setup-keyboard-shortcut.sh
```

The script auto-detects your desktop environment and configures the shortcut automatically.

**Supported desktop environments:**
- XFCE
- GNOME / Unity / Budgie
- Cinnamon
- MATE
- KDE Plasma
- i3 / Sway
- LXDE / LXQt (Openbox-based)

**📚 Documentation:**

- **[Keyboard Shortcuts Guide](docs/KEYBOARD_SHORTCUTS.md)** - Complete guide with troubleshooting and manual setup instructions
- **[Quick Reference](docs/QUICK_REFERENCE.md)** - One-page cheat sheet

**Manual setup:**

If the automatic setup doesn't work, see the [manual configuration section](docs/KEYBOARD_SHORTCUTS.md#manual-configuration) in the guide.

## Data format

Ideas are stored in:

- Linux: `~/.local/share/memo-tori/ideas.txt` (or `$XDG_DATA_HOME/memo-tori/ideas.txt`)
- Windows: `%APPDATA%\\memo-tori\\ideas.txt`

using plain text blocks separated by a line containing:

```
---
```

Example:

```
First idea text
---
Second idea text
```

The 300-character preview is only visual. The full text is stored.

To override the storage location, set `MEMO_TORI_DATA_DIR` before launch.

## Project structure

- `memo-tori.py` - Python entrypoint and storage logic
- `web/index.html` - UI markup
- `web/style.css` - UI styles
- `web/app.js` - UI logic
- `data/ideas.txt` - local data file

## License

MIT
