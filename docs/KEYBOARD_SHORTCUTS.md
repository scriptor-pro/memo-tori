# Keyboard Shortcuts Guide

This guide explains how to set up and use keyboard shortcuts to launch Memo Tori quickly on Linux.

## Table of Contents

- [Quick Setup](#quick-setup)
- [Supported Desktop Environments](#supported-desktop-environments)
- [Troubleshooting](#troubleshooting)
- [Manual Configuration](#manual-configuration)
- [Advanced Topics](#advanced-topics)

---

## Quick Setup

### Automatic Setup (Recommended)

The easiest way to set up a keyboard shortcut is to run the automated setup script:

```bash
cd /path/to/memo-tori
bash scripts/setup-keyboard-shortcut.sh
```

This will:
1. Detect your desktop environment automatically
2. Configure **Super+M** (Windows key + M) as the launch shortcut
3. Provide confirmation and any necessary next steps

**Note**: "Super" refers to the Windows key on PC keyboards or the Command key on Mac keyboards.

### What Happens Next?

After running the script:
- Press **Super+M** to instantly launch Memo Tori
- The app opens in a new window ready to capture your idea
- You can use the shortcut anytime, from any application

---

## Supported Desktop Environments

The automated script supports the following desktop environments:

### ✅ XFCE
- **Method**: Uses `xfconf-query` to modify keyboard shortcuts
- **Config**: Stored in xfce4-keyboard-shortcuts channel
- **Takes effect**: Immediately
- **Verification**: Check Settings → Keyboard → Application Shortcuts

### ✅ GNOME / Unity / Budgie
- **Method**: Uses `gsettings` with GNOME schema
- **Config**: Stored in dconf database
- **Takes effect**: Immediately
- **Verification**: Check Settings → Keyboard → Custom Shortcuts

### ✅ Cinnamon
- **Method**: Uses `gsettings` with Cinnamon-specific schema
- **Config**: Stored in dconf database
- **Takes effect**: Immediately
- **Verification**: Check System Settings → Keyboard → Shortcuts → Custom Shortcuts

### ✅ MATE
- **Method**: Uses `gsettings` with MATE schema (Marco window manager)
- **Config**: Stored in dconf database
- **Takes effect**: Immediately
- **Verification**: Check System → Preferences → Hardware → Keyboard Shortcuts

### ✅ KDE Plasma
- **Method**: Uses `kwriteconfig5` to modify khotkeys configuration
- **Config**: Stored in `~/.config/khotkeysrc`
- **Takes effect**: After logging out/in or restarting khotkeys daemon
- **Verification**: Check System Settings → Shortcuts → Custom Shortcuts

### ✅ i3 / Sway
- **Method**: Appends binding to config file
- **Config**: `~/.config/i3/config` or `~/.config/sway/config`
- **Takes effect**: After reloading config (Mod+Shift+R)
- **Note**: Uses `$mod+m` (your configured modifier key + M)

### ✅ LXDE / LXQt (Openbox-based)
- **Method**: Modifies Openbox XML configuration (requires `xmlstarlet`)
- **Config**: `~/.config/openbox/lxde-rc.xml` or `~/.config/openbox/rc.xml`
- **Takes effect**: After running `openbox --reconfigure` or logging out/in
- **Note**: Uses `W-m` (Windows key + M)

---

## Troubleshooting

### Problem: "Unknown or unsupported desktop environment"

**Solution**: The script couldn't detect your DE automatically. Try:

1. Check your desktop environment:
   ```bash
   echo $XDG_CURRENT_DESKTOP
   echo $DESKTOP_SESSION
   ```

2. Configure manually using your DE's settings (see [Manual Configuration](#manual-configuration))

### Problem: "Command not found" errors

**Possible causes and solutions**:

- **XFCE**: Install `xfce4-settings`
  ```bash
  sudo apt install xfce4-settings
  ```

- **GNOME/MATE/Cinnamon**: Install `gsettings` (usually part of glib2)
  ```bash
  sudo apt install libglib2.0-bin
  ```

- **KDE**: Install `kwriteconfig5` (part of KDE frameworks)
  ```bash
  sudo apt install libkf5config-bin
  ```

- **LXDE/LXQt**: Install `xmlstarlet` for automatic configuration
  ```bash
  sudo apt install xmlstarlet
  ```

### Problem: Shortcut doesn't work after setup

**Check these common issues**:

1. **XFCE**: Make sure the xfce4-keyboard-plugin is running
   ```bash
   xfconf-query -c xfce4-keyboard-shortcuts -lv | grep "Super>m"
   ```

2. **GNOME/Cinnamon/MATE**: Verify the keybinding is registered
   ```bash
   gsettings list-recursively | grep -i "memo-tori"
   ```

3. **KDE**: You may need to log out and back in, or restart khotkeys:
   ```bash
   kquitapp5 khotkeys && kstart5 khotkeys
   ```

4. **i3/Sway**: Reload the configuration:
   - Press `Mod+Shift+R` (default i3/Sway reload binding)
   - Or run: `i3-msg reload` or `swaymsg reload`

5. **LXDE/LXQt**: Reconfigure Openbox:
   ```bash
   openbox --reconfigure
   ```

### Problem: Super+M conflicts with another shortcut

**Solution**: Choose a different key combination by editing the script:

1. Open the script:
   ```bash
   nano scripts/setup-keyboard-shortcut.sh
   ```

2. Change line 5 from:
   ```bash
   SHORTCUT_KEY="Super+M"
   ```
   to your preferred combination, e.g.:
   ```bash
   SHORTCUT_KEY="Super+Shift+M"
   ```

3. Update the key bindings in each DE's setup function accordingly (e.g., `<Super>m` → `<Super><Shift>m`)

### Problem: "gtk-launch memo-tori" not working

**This means Memo Tori is not installed system-wide.**

**Solution**: Use the full path instead:

1. Edit your desktop environment's shortcut and replace:
   ```
   gtk-launch memo-tori
   ```
   with:
   ```
   /path/to/memo-tori/.venv/bin/python3 /path/to/memo-tori/memo-tori.py
   ```

   Or run the setup script again - it should auto-detect if you're running from source.

---

## Manual Configuration

If the automated script doesn't work for your desktop environment, follow these DE-specific instructions:

### Command to Use

Choose the appropriate command based on your installation:

**Installed via .deb package**:
```bash
gtk-launch memo-tori
```

**Running from source**:
```bash
/home/Baudouin/Documents/Projets/Memo-Tori/.venv/bin/python3 /home/Baudouin/Documents/Projets/Memo-Tori/memo-tori.py
```

Replace the path with your actual installation directory.

### XFCE Manual Setup

1. Open **Settings Manager**
2. Go to **Keyboard** → **Application Shortcuts** tab
3. Click **Add** button
4. Enter the command (see above)
5. Press **Super+M** (or your preferred keys) when prompted
6. Click **OK**

### GNOME Manual Setup

1. Open **Settings**
2. Go to **Keyboard** → **Keyboard Shortcuts**
3. Scroll down and click **View and Customize Shortcuts**
4. Click **Custom Shortcuts** at the bottom
5. Click the **+** button to add a new shortcut
6. Enter:
   - **Name**: Launch Memo Tori
   - **Command**: (see command above)
   - **Shortcut**: Click "Set Shortcut" and press Super+M
7. Click **Add**

### KDE Plasma Manual Setup

1. Open **System Settings**
2. Go to **Shortcuts** → **Custom Shortcuts**
3. Click **Edit** → **New** → **Global Shortcut** → **Command/URL**
4. In the "Action" tab, enter:
   - **Command/URL**: (see command above)
5. In the "Trigger" tab:
   - Click the button next to "Shortcut"
   - Press **Meta+M** (Meta is the Super/Windows key)
6. Click **OK** and **Apply**

### MATE Manual Setup

1. Open **System** → **Preferences** → **Hardware** → **Keyboard Shortcuts**
2. Click **Add**
3. Enter:
   - **Name**: Launch Memo Tori
   - **Command**: (see command above)
4. Click **Apply**
5. Click on the new entry and press **Super+M**

### Cinnamon Manual Setup

1. Open **System Settings**
2. Go to **Keyboard** → **Shortcuts** tab
3. Click **Custom Shortcuts** category
4. Click the **+** button
5. Enter:
   - **Name**: Launch Memo Tori
   - **Command**: (see command above)
6. Click **Add**
7. Click on the new entry and press **Super+M**

### i3 / Sway Manual Setup

1. Open your config file:
   ```bash
   nano ~/.config/i3/config
   # or for Sway:
   nano ~/.config/sway/config
   ```

2. Add this line:
   ```
   bindsym $mod+m exec /path/to/.venv/bin/python3 /path/to/memo-tori.py
   ```

3. Save the file and reload the configuration:
   - Press **Mod+Shift+R**
   - Or run: `i3-msg reload` or `swaymsg reload`

### LXDE / LXQt Manual Setup

1. Open your Openbox configuration:
   ```bash
   nano ~/.config/openbox/lxde-rc.xml
   # or:
   nano ~/.config/openbox/rc.xml
   ```

2. Find the `<keyboard>` section

3. Add this inside the `<keyboard>` section:
   ```xml
   <keybind key="W-m">
     <action name="Execute">
       <command>/path/to/.venv/bin/python3 /path/to/memo-tori.py</command>
     </action>
   </keybind>
   ```

4. Save the file and reconfigure Openbox:
   ```bash
   openbox --reconfigure
   ```

---

## Advanced Topics

### Changing the Shortcut Key

The default shortcut is **Super+M**, but you can customize it:

1. **Modify the script**: Edit `scripts/setup-keyboard-shortcut.sh` and change the `SHORTCUT_KEY` variable and all DE-specific key bindings

2. **Or configure manually**: Use your DE's settings to change the shortcut after running the automated setup

### Multiple Shortcuts

You can set up additional shortcuts if desired:

- **Example use case**: Super+M to open a new window, Super+Shift+M to show existing window

### Running Without Virtual Environment

If you want to make the shortcut simpler, you can:

1. Install Memo Tori system-wide via a .deb package (see packaging documentation)
2. Create a wrapper script in `/usr/local/bin/`
3. Use that wrapper as the command instead

### Integration with Custom Launchers

If you use a custom launcher like:
- **Rofi**
- **dmenu**
- **Albert**
- **Ulauncher**

Memo Tori will appear automatically in these launchers after you copy the `.desktop` file to `~/.local/share/applications/`.

### Checking Active Shortcuts

**XFCE**:
```bash
xfconf-query -c xfce4-keyboard-shortcuts -lv | grep memo
```

**GNOME/Cinnamon/MATE**:
```bash
gsettings list-recursively | grep -i memo
```

**KDE**:
```bash
grep -r "memo" ~/.config/khotkeysrc
```

**i3/Sway**:
```bash
grep "memo" ~/.config/i3/config
# or:
grep "memo" ~/.config/sway/config
```

**LXDE/LXQt**:
```bash
grep -A5 "W-m" ~/.config/openbox/*rc.xml
```

### Removing the Shortcut

**XFCE**:
```bash
xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/<Super>m" --reset
```

**GNOME/Cinnamon/MATE**:
Use the settings GUI to remove the custom shortcut, or use gsettings to reset the schema.

**KDE**:
Remove the `Data_memo_tori` section from `~/.config/khotkeysrc` and restart khotkeys.

**i3/Sway**:
Remove the `bindsym $mod+m` line from your config and reload.

**LXDE/LXQt**:
Remove the `<keybind key="W-m">` block from your Openbox config and reconfigure.

---

## Tips and Best Practices

1. **Test first**: After setup, test the shortcut immediately to ensure it works

2. **Check conflicts**: Make sure Super+M isn't already used by another application

3. **Document custom changes**: If you modify the shortcut, keep notes for future reference

4. **Version control**: If you use multiple machines, keep your config files in version control

5. **Backup configs**: Before running automated scripts, backup your DE's config files

---

## Getting Help

If you encounter issues not covered in this guide:

1. Check the main [README.md](../README.md) for general setup information
2. Review the [troubleshooting section](#troubleshooting) above
3. Examine the script output for specific error messages
4. Check your desktop environment's documentation for keyboard shortcut configuration

---

**Last updated**: 2025-12-29
