# Memo Tori Installation & Setup Guide

Complete step-by-step guide for installing Memo Tori and setting up the keyboard shortcut.

---

## 📋 Prerequisites

### System Requirements

- **Operating System**: Linux (Debian 11+, Ubuntu 20.04+, Fedora 36+, Arch, or compatible)
- **Python**: Python 3.10 or newer
- **Desktop Environment**: Any supported DE (XFCE, GNOME, KDE, MATE, Cinnamon, i3, Sway, LXDE, LXQt)

### Required System Packages

**Debian / Ubuntu / MX Linux / Linux Mint:**
```bash
sudo apt update
sudo apt install -y python3-venv python3-pip python3-gi gir1.2-gtk-3.0 gir1.2-webkit2-4.0
```

**Fedora:**
```bash
sudo dnf install -y python3 python3-pip python3-gobject gtk3 webkit2gtk4.0
```

**Arch / Manjaro:**
```bash
sudo pacman -S python python-pip python-gobject gtk3 webkit2gtk
```

---

## 🚀 Installation Methods

### Method 1: From Source (Development)

**Step 1: Clone or download the repository**
```bash
cd ~/Documents/Projects
# If you have the source already, skip to step 2
```

**Step 2: Create Python virtual environment**
```bash
cd /path/to/memo-tori
python3 -m venv --system-site-packages .venv
```

**Note for Debian/MX Linux users**: If your default Python is not 3.11, use:
```bash
/usr/bin/python3.11 -m venv --system-site-packages .venv
```

**Step 3: Activate the virtual environment**
```bash
source .venv/bin/activate
```

**Step 4: Install Python dependencies**
```bash
pip install -r requirements.txt
```

**Step 5: Test the installation**
```bash
python3 memo-tori.py
```

You should see the Memo Tori window open. If it works, close it and proceed to desktop integration.

### Method 2: Install from .deb Package (Recommended for Debian/Ubuntu)

**Step 1: Build the .deb package**
```bash
cd /path/to/memo-tori
bash scripts/build-deb.sh
```

**Step 2: Install the package**
```bash
sudo dpkg -i memo-tori_*.deb
sudo apt-get install -f  # Fix any missing dependencies
```

**Step 3: Test the installation**
```bash
memo-tori
```

### Method 3: Windows Installation

See the [Windows installer section](../README.md#windows-installer) in the main README.

---

## 🖥️ Desktop Integration

### Add to Application Launcher

**If running from source:**
```bash
mkdir -p ~/.local/share/applications
cp /path/to/memo-tori/memo-tori.desktop ~/.local/share/applications/
```

**If installed from .deb:**
The desktop file is automatically installed to `/usr/share/applications/`.

**Verify it appears in your app launcher:**
- Open your application menu
- Search for "Memo Tori"
- You should see the icon and be able to launch it

---

## ⌨️ Keyboard Shortcut Setup

### Automatic Setup (Recommended)

**Run the setup script:**
```bash
cd /path/to/memo-tori
bash scripts/setup-keyboard-shortcut.sh
```

**What the script does:**
1. Detects your desktop environment
2. Configures **Super+M** as the launch shortcut
3. Confirms the setup is complete

**Expected output:**
```
==================================
Memo Tori Keyboard Shortcut Setup
==================================

Shortcut: Super+M
Command: gtk-launch memo-tori

Detected Desktop Environment: xfce

Setting up keyboard shortcut for XFCE...
Creating new shortcut...
✓ XFCE keyboard shortcut configured successfully!

==================================
Setup complete! Press Super+M to launch Memo Tori.
==================================
```

### Verify the Shortcut

1. Press **Super+M** (Windows/Command key + M)
2. Memo Tori should open immediately
3. If it doesn't work, see the [troubleshooting guide](KEYBOARD_SHORTCUTS.md#troubleshooting)

### Manual Setup

If the automatic setup doesn't work for your desktop environment, see the [manual configuration guide](KEYBOARD_SHORTCUTS.md#manual-configuration).

---

## ✅ Post-Installation Checklist

After installation, verify everything is working:

- [ ] **Application launches**: Can you start Memo Tori from the command line?
- [ ] **Desktop integration**: Does Memo Tori appear in your application menu?
- [ ] **Keyboard shortcut**: Does Super+M launch the application?
- [ ] **Save functionality**: Can you save an idea?
- [ ] **View functionality**: Can you view saved ideas?
- [ ] **Delete functionality**: Can you delete ideas?
- [ ] **Data persistence**: Are ideas still there after closing and reopening?

---

## 🗂️ Data Storage Location

Memo Tori stores your ideas in plain text format:

**Linux:**
```
~/.local/share/memo-tori/ideas.txt
```

**Windows:**
```
%APPDATA%\memo-tori\ideas.txt
```

**Custom location:**
Set the `MEMO_TORI_DATA_DIR` environment variable before launching:
```bash
export MEMO_TORI_DATA_DIR=/custom/path
```

---

## 🔧 Configuration

### Changing the Data Directory

**Temporary (one session):**
```bash
export MEMO_TORI_DATA_DIR=~/Documents/my-ideas
python3 memo-tori.py
```

**Permanent (add to ~/.bashrc or ~/.zshrc):**
```bash
echo 'export MEMO_TORI_DATA_DIR=~/Documents/my-ideas' >> ~/.bashrc
source ~/.bashrc
```

### Customizing the Desktop Entry

Edit `~/.local/share/applications/memo-tori.desktop` to customize:
- **Name**: Change "Memo Tori" to your preference
- **Icon**: Point to a custom icon file
- **Exec**: Add custom startup options or environment variables

Example with custom data directory:
```desktop
[Desktop Entry]
Type=Application
Name=My Ideas
Comment=Capture ideas quickly
Exec=env MEMO_TORI_DATA_DIR=/home/user/my-ideas /path/to/.venv/bin/python3 /path/to/memo-tori.py
Icon=/path/to/custom-icon.png
Terminal=false
Categories=Utility;
```

---

## 🔄 Updating Memo Tori

### From Source

**Step 1: Pull latest changes** (if using git)
```bash
cd /path/to/memo-tori
git pull
```

**Step 2: Update dependencies**
```bash
source .venv/bin/activate
pip install --upgrade -r requirements.txt
```

**Step 3: Update desktop integration**
```bash
cp memo-tori.desktop ~/.local/share/applications/
```

**Step 4: Update keyboard shortcut** (if command changed)
```bash
bash scripts/setup-keyboard-shortcut.sh
```

### From .deb Package

**Step 1: Build new package**
```bash
cd /path/to/memo-tori
bash scripts/build-deb.sh
```

**Step 2: Install the update**
```bash
sudo dpkg -i memo-tori_*.deb
```

---

## 🗑️ Uninstallation

### From Source

**Step 1: Remove desktop integration**
```bash
rm ~/.local/share/applications/memo-tori.desktop
```

**Step 2: Remove keyboard shortcut**

See the [removing shortcuts section](KEYBOARD_SHORTCUTS.md#removing-the-shortcut) in the keyboard guide.

**Step 3: Remove application files**
```bash
rm -rf /path/to/memo-tori
```

**Step 4: (Optional) Remove data**
```bash
rm -rf ~/.local/share/memo-tori
```

⚠️ **Warning**: This deletes all your saved ideas permanently!

### From .deb Package

**Uninstall but keep data:**
```bash
sudo apt remove memo-tori
```

**Uninstall and remove all data:**
```bash
sudo apt purge memo-tori
rm -rf ~/.local/share/memo-tori
```

---

## 🆘 Troubleshooting Installation Issues

### Problem: "python3-gi not found" or similar

**Solution**: Install the required system packages for your distribution (see [Prerequisites](#prerequisites))

### Problem: Virtual environment creation fails

**Solution**: Make sure python3-venv is installed:
```bash
sudo apt install python3-venv  # Debian/Ubuntu
sudo dnf install python3        # Fedora
sudo pacman -S python           # Arch
```

### Problem: "ModuleNotFoundError: No module named 'webview'"

**Solution**: Activate the virtual environment and install dependencies:
```bash
source .venv/bin/activate
pip install -r requirements.txt
```

### Problem: Application won't start - "gi.repository" errors

**Solution**: Make sure you created the venv with `--system-site-packages`:
```bash
rm -rf .venv
python3 -m venv --system-site-packages .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### Problem: Desktop file doesn't appear in menu

**Solution**: Update the desktop database:
```bash
update-desktop-database ~/.local/share/applications/
```

Wait a few seconds, then check your application menu again.

### Problem: Keyboard shortcut setup script fails

**Solution**: See the comprehensive [troubleshooting section](KEYBOARD_SHORTCUTS.md#troubleshooting) in the keyboard shortcuts guide.

---

## 📚 Next Steps

After successful installation:

1. **Read the [Quick Reference](QUICK_REFERENCE.md)** for handy commands
2. **Check out [Keyboard Shortcuts Guide](KEYBOARD_SHORTCUTS.md)** for customization options
3. **Start using Memo Tori** - Press Super+M and capture your first idea!

---

## 🤝 Getting Help

If you encounter issues not covered here:

1. Check the [Keyboard Shortcuts Guide](KEYBOARD_SHORTCUTS.md) for shortcut-specific issues
2. Review the [main README](../README.md) for general information
3. Check system logs for error messages
4. Verify all prerequisites are installed

---

**Last updated**: 2025-12-29
