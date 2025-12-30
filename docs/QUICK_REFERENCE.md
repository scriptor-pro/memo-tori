# Keyboard Shortcut Quick Reference

**One-page guide for setting up Memo Tori keyboard shortcuts**

---

## 🚀 Quick Setup (30 seconds)

```bash
cd /path/to/memo-tori
bash scripts/setup-keyboard-shortcut.sh
```

Then press **Super+M** (Windows key + M) to launch Memo Tori!

---

## 📋 Supported Desktop Environments

| Desktop Environment | Auto-Setup | Config Method |
|---------------------|------------|---------------|
| XFCE | ✅ | xfconf-query |
| GNOME / Unity / Budgie | ✅ | gsettings |
| Cinnamon | ✅ | gsettings |
| MATE | ✅ | gsettings |
| KDE Plasma | ✅ | kwriteconfig5 |
| i3 / Sway | ✅ | config file |
| LXDE / LXQt | ✅ | Openbox XML |

---

## 🔧 Manual Setup Commands

### Get the Command

**Installed via .deb**:
```bash
gtk-launch memo-tori
```

**Running from source**:
```bash
/path/to/.venv/bin/python3 /path/to/memo-tori.py
```

### Desktop Environment Settings

| DE | Path to Settings |
|----|-----------------|
| **XFCE** | Settings → Keyboard → Application Shortcuts |
| **GNOME** | Settings → Keyboard → Custom Shortcuts |
| **KDE** | System Settings → Shortcuts → Custom Shortcuts |
| **MATE** | System → Preferences → Hardware → Keyboard Shortcuts |
| **Cinnamon** | System Settings → Keyboard → Shortcuts |
| **i3/Sway** | Edit `~/.config/i3/config` or `~/.config/sway/config` |
| **LXDE/LXQt** | Edit `~/.config/openbox/lxde-rc.xml` |

---

## 🐛 Quick Troubleshooting

### Shortcut Not Working?

**XFCE**: Verify the setting
```bash
xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/<Super>m"
```

**GNOME/Cinnamon/MATE**: Check gsettings
```bash
gsettings list-recursively | grep -i memo
```

**KDE**: Log out and back in, or restart khotkeys
```bash
kquitapp5 khotkeys && kstart5 khotkeys
```

**i3/Sway**: Reload config
```
Mod+Shift+R  (or: i3-msg reload / swaymsg reload)
```

**LXDE/LXQt**: Reconfigure Openbox
```bash
openbox --reconfigure
```

### Missing Commands?

| Error | Install Package |
|-------|----------------|
| `xfconf-query: command not found` | `sudo apt install xfce4-settings` |
| `gsettings: command not found` | `sudo apt install libglib2.0-bin` |
| `kwriteconfig5: command not found` | `sudo apt install libkf5config-bin` |
| `xmlstarlet: command not found` | `sudo apt install xmlstarlet` |

---

## 🎹 Default Shortcut

**Super+M** (Windows/Command key + M)

To use a different shortcut, manually configure it in your DE's settings after running the setup script.

---

## 📚 Full Documentation

For detailed information, troubleshooting, and advanced topics, see:
- [Complete Keyboard Shortcuts Guide](KEYBOARD_SHORTCUTS.md)
- [Main README](../README.md)

---

**Need help?** Check the [troubleshooting section](KEYBOARD_SHORTCUTS.md#troubleshooting) in the full guide.
