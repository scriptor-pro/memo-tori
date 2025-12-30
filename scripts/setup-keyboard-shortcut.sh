#!/bin/bash
# Setup keyboard shortcut (Super+M) for Memo Tori across different desktop environments

set -e

SHORTCUT_KEY="Super+M"
SHORTCUT_NAME="Launch Memo Tori"

# Detect if running from source or installed
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Check if installed via .deb (gtk-launch works)
if command -v gtk-launch &> /dev/null && gtk-launch --version &> /dev/null; then
    LAUNCH_COMMAND="gtk-launch memo-tori"
else
    # Running from source - use full path
    VENV_PYTHON="$PROJECT_ROOT/.venv/bin/python3"
    MAIN_SCRIPT="$PROJECT_ROOT/memo-tori.py"
    
    if [ -f "$VENV_PYTHON" ] && [ -f "$MAIN_SCRIPT" ]; then
        LAUNCH_COMMAND="$VENV_PYTHON $MAIN_SCRIPT"
    else
        echo "Error: Could not find venv Python or memo-tori.py"
        echo "Expected: $VENV_PYTHON and $MAIN_SCRIPT"
        exit 1
    fi
fi

echo "=================================="
echo "Memo Tori Keyboard Shortcut Setup"
echo "=================================="
echo ""
echo "Shortcut: $SHORTCUT_KEY"
echo "Command: $LAUNCH_COMMAND"
echo ""

# Detect desktop environment
detect_de() {
    if [ -n "$XDG_CURRENT_DESKTOP" ]; then
        echo "$XDG_CURRENT_DESKTOP" | tr '[:upper:]' '[:lower:]'
    elif [ -n "$DESKTOP_SESSION" ]; then
        echo "$DESKTOP_SESSION" | tr '[:upper:]' '[:lower:]'
    else
        echo "unknown"
    fi
}

DE=$(detect_de)
echo "Detected Desktop Environment: $DE"
echo ""

# Function to setup XFCE shortcut
setup_xfce() {
    echo "Setting up keyboard shortcut for XFCE..."
    
    # XFCE stores keyboard shortcuts in xfconf
    if ! command -v xfconf-query &> /dev/null; then
        echo "Error: xfconf-query not found. Please install xfce4-settings."
        return 1
    fi
    
    # Check if the shortcut already exists
    EXISTING=$(xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/<Super>m" 2>/dev/null || true)
    
    if [ -n "$EXISTING" ]; then
        echo "Shortcut Super+M already exists in XFCE. Updating..."
        xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/<Super>m" -s "$LAUNCH_COMMAND"
    else
        echo "Creating new shortcut..."
        xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/<Super>m" --create -t string -s "$LAUNCH_COMMAND"
    fi
    
    echo "✓ XFCE keyboard shortcut configured successfully!"
    return 0
}

# Function to setup GNOME shortcut
setup_gnome() {
    echo "Setting up keyboard shortcut for GNOME..."
    
    if ! command -v gsettings &> /dev/null; then
        echo "Error: gsettings not found. Cannot configure GNOME shortcuts."
        return 1
    fi
    
    # Get current custom keybindings
    CUSTOM_KEYBINDINGS=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)
    
    # Find a new slot
    NEW_INDEX=0
    while echo "$CUSTOM_KEYBINDINGS" | grep -q "custom$NEW_INDEX"; do
        NEW_INDEX=$((NEW_INDEX + 1))
    done
    
    CUSTOM_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$NEW_INDEX/"
    
    # Add the new custom keybinding path to the list
    if [ "$CUSTOM_KEYBINDINGS" = "@as []" ] || [ "$CUSTOM_KEYBINDINGS" = "[]" ]; then
        NEW_LIST="['$CUSTOM_PATH']"
    else
        # Remove the closing bracket and add new path
        NEW_LIST=$(echo "$CUSTOM_KEYBINDINGS" | sed "s/]$/, '$CUSTOM_PATH']/")
    fi
    
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$NEW_LIST"
    
    # Set the actual keybinding properties
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$CUSTOM_PATH name "$SHORTCUT_NAME"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$CUSTOM_PATH command "$LAUNCH_COMMAND"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$CUSTOM_PATH binding "<Super>m"
    
    echo "✓ GNOME keyboard shortcut configured successfully!"
    return 0
}

# Function to setup KDE shortcut
setup_kde() {
    echo "Setting up keyboard shortcut for KDE Plasma..."
    
    # KDE uses khotkeys for custom shortcuts
    KHOTKEYS_FILE="$HOME/.config/khotkeysrc"
    
    # Check if kwriteconfig5 is available for easier configuration
    if command -v kwriteconfig5 &> /dev/null; then
        # Create a new data group for our shortcut
        GROUP_NAME="Data_memo_tori"
        
        # Write the shortcut configuration
        kwriteconfig5 --file khotkeysrc --group "$GROUP_NAME" --key Comment "Launch Memo Tori"
        kwriteconfig5 --file khotkeysrc --group "$GROUP_NAME" --key DataCount 1
        kwriteconfig5 --file khotkeysrc --group "$GROUP_NAME" --key Enabled true
        kwriteconfig5 --file khotkeysrc --group "$GROUP_NAME" --key Name "Memo Tori"
        kwriteconfig5 --file khotkeysrc --group "$GROUP_NAME" --key SystemGroup 0
        kwriteconfig5 --file khotkeysrc --group "$GROUP_NAME" --key Type "ACTION_DATA_GROUP"
        
        kwriteconfig5 --file khotkeysrc --group "${GROUP_NAME}_1" --key Comment "Launch Memo Tori with Super+M"
        kwriteconfig5 --file khotkeysrc --group "${GROUP_NAME}_1" --key Enabled true
        kwriteconfig5 --file khotkeysrc --group "${GROUP_NAME}_1" --key Name "Launch Memo Tori"
        kwriteconfig5 --file khotkeysrc --group "${GROUP_NAME}_1" --key Type "SIMPLE_ACTION_DATA"
        
        kwriteconfig5 --file khotkeysrc --group "${GROUP_NAME}_1Triggers" --key Comment "Simple_action"
        kwriteconfig5 --file khotkeysrc --group "${GROUP_NAME}_1Triggers" --key TriggersCount 1
        
        kwriteconfig5 --file khotkeysrc --group "${GROUP_NAME}_1Triggers0" --key Key "Meta+M"
        kwriteconfig5 --file khotkeysrc --group "${GROUP_NAME}_1Triggers0" --key Type "SHORTCUT"
        kwriteconfig5 --file khotkeysrc --group "${GROUP_NAME}_1Triggers0" --key Uuid "{$(uuidgen)}"
        
        kwriteconfig5 --file khotkeysrc --group "${GROUP_NAME}_1Actions" --key ActionsCount 1
        
        kwriteconfig5 --file khotkeysrc --group "${GROUP_NAME}_1Actions0" --key CommandURL "$LAUNCH_COMMAND"
        kwriteconfig5 --file khotkeysrc --group "${GROUP_NAME}_1Actions0" --key Type "COMMAND_URL"
        
        # Restart khotkeys to apply changes
        if command -v kquitapp5 &> /dev/null && command -v kstart5 &> /dev/null; then
            kquitapp5 khotkeys 2>/dev/null || true
            sleep 1
            kstart5 khotkeys 2>/dev/null || true
        fi
        
        echo "✓ KDE keyboard shortcut configured successfully!"
        echo "Note: You may need to log out and back in for changes to take effect."
        return 0
    else
        echo "Error: kwriteconfig5 not found. Cannot configure KDE shortcuts automatically."
        echo "Please configure manually:"
        echo "  System Settings → Shortcuts → Custom Shortcuts → Edit → New → Global Shortcut → Command/URL"
        echo "  Command: $LAUNCH_COMMAND"
        echo "  Shortcut: Meta+M"
        return 1
    fi
}

# Function to setup MATE shortcut
setup_mate() {
    echo "Setting up keyboard shortcut for MATE..."
    
    if ! command -v gsettings &> /dev/null; then
        echo "Error: gsettings not found. Cannot configure MATE shortcuts."
        return 1
    fi
    
    # MATE uses similar structure to GNOME but different schema
    CUSTOM_KEYBINDINGS=$(gsettings get org.mate.Marco.global-keybindings custom-list 2>/dev/null || echo "[]")
    
    # Find a new slot
    NEW_INDEX=0
    while echo "$CUSTOM_KEYBINDINGS" | grep -q "custom$NEW_INDEX"; do
        NEW_INDEX=$((NEW_INDEX + 1))
    done
    
    CUSTOM_NAME="custom$NEW_INDEX"
    
    # Add the new custom keybinding to the list
    if [ "$CUSTOM_KEYBINDINGS" = "[]" ] || [ "$CUSTOM_KEYBINDINGS" = "@as []" ]; then
        NEW_LIST="['$CUSTOM_NAME']"
    else
        NEW_LIST=$(echo "$CUSTOM_KEYBINDINGS" | sed "s/]$/, '$CUSTOM_NAME']/")
    fi
    
    gsettings set org.mate.Marco.global-keybindings custom-list "$NEW_LIST"
    
    # Set the keybinding properties
    gsettings set org.mate.Marco.keybinding-commands "command-$NEW_INDEX" "$LAUNCH_COMMAND"
    gsettings set org.mate.Marco.global-keybindings "run-command-$NEW_INDEX" "<Mod4>m"
    
    echo "✓ MATE keyboard shortcut configured successfully!"
    return 0
}

# Function to setup Cinnamon shortcut
setup_cinnamon() {
    echo "Setting up keyboard shortcut for Cinnamon..."
    
    if ! command -v gsettings &> /dev/null; then
        echo "Error: gsettings not found. Cannot configure Cinnamon shortcuts."
        return 1
    fi
    
    # Cinnamon uses custom keybindings similar to GNOME
    CUSTOM_KEYBINDINGS=$(gsettings get org.cinnamon.desktop.keybindings custom-list 2>/dev/null || echo "[]")
    
    # Find a new slot
    NEW_INDEX=0
    while echo "$CUSTOM_KEYBINDINGS" | grep -q "custom$NEW_INDEX"; do
        NEW_INDEX=$((NEW_INDEX + 1))
    done
    
    CUSTOM_NAME="custom$NEW_INDEX"
    
    # Add the new custom keybinding to the list
    if [ "$CUSTOM_KEYBINDINGS" = "[]" ] || [ "$CUSTOM_KEYBINDINGS" = "@as []" ]; then
        NEW_LIST="['$CUSTOM_NAME']"
    else
        NEW_LIST=$(echo "$CUSTOM_KEYBINDINGS" | sed "s/]$/, '$CUSTOM_NAME']/")
    fi
    
    gsettings set org.cinnamon.desktop.keybindings custom-list "$NEW_LIST"
    gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/$CUSTOM_NAME/ name "$SHORTCUT_NAME"
    gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/$CUSTOM_NAME/ command "$LAUNCH_COMMAND"
    gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/$CUSTOM_NAME/ binding "['<Super>m']"
    
    echo "✓ Cinnamon keyboard shortcut configured successfully!"
    return 0
}

# Function to setup i3/Sway shortcut
setup_i3() {
    echo "Setting up keyboard shortcut for i3/Sway..."
    
    # Detect whether it's i3 or sway
    I3_CONFIG=""
    if [ -f "$HOME/.config/i3/config" ]; then
        I3_CONFIG="$HOME/.config/i3/config"
    elif [ -f "$HOME/.i3/config" ]; then
        I3_CONFIG="$HOME/.i3/config"
    elif [ -f "$HOME/.config/sway/config" ]; then
        I3_CONFIG="$HOME/.config/sway/config"
    else
        echo "Error: Could not find i3 or sway config file."
        echo "Expected locations:"
        echo "  - ~/.config/i3/config"
        echo "  - ~/.i3/config"
        echo "  - ~/.config/sway/config"
        return 1
    fi
    
    # Check if the binding already exists
    if grep -q "bindsym \$mod+m exec.*memo-tori" "$I3_CONFIG" 2>/dev/null; then
        echo "Shortcut Mod+M already exists in config. Updating..."
        sed -i "s|bindsym \$mod+m exec.*memo-tori.*|bindsym \$mod+m exec $LAUNCH_COMMAND|" "$I3_CONFIG"
    else
        echo "Adding new shortcut to config..."
        echo "" >> "$I3_CONFIG"
        echo "# Memo Tori keyboard shortcut (added by setup script)" >> "$I3_CONFIG"
        echo "bindsym \$mod+m exec $LAUNCH_COMMAND" >> "$I3_CONFIG"
    fi
    
    echo "✓ i3/Sway keyboard shortcut configured successfully!"
    echo "Note: Reload your i3/Sway config (Mod+Shift+R) for changes to take effect."
    return 0
}

# Function to setup LXDE/LXQt shortcut (openbox-based)
setup_lxde() {
    echo "Setting up keyboard shortcut for LXDE/LXQt..."
    
    # LXDE typically uses Openbox
    OPENBOX_CONFIG="$HOME/.config/openbox/lxde-rc.xml"
    if [ ! -f "$OPENBOX_CONFIG" ]; then
        OPENBOX_CONFIG="$HOME/.config/openbox/rc.xml"
    fi
    
    if [ ! -f "$OPENBOX_CONFIG" ]; then
        echo "Error: Could not find Openbox config file."
        echo "Expected: ~/.config/openbox/lxde-rc.xml or ~/.config/openbox/rc.xml"
        return 1
    fi
    
    # Check if xmlstarlet is available for proper XML editing
    if command -v xmlstarlet &> /dev/null; then
        # Use xmlstarlet to add the keybinding properly
        xmlstarlet ed --inplace \
            -s "/_:openbox_config/_:keyboard" -t elem -n "keybind" -v "" \
            -i "//keybind[last()]" -t attr -n "key" -v "W-m" \
            -s "//keybind[last()]" -t elem -n "action" -v "" \
            -i "//keybind[last()]/action" -t attr -n "name" -v "Execute" \
            -s "//keybind[last()]/action" -t elem -n "command" -v "$LAUNCH_COMMAND" \
            "$OPENBOX_CONFIG" 2>/dev/null || {
                echo "Note: Could not automatically add keybinding to XML."
                echo "Please add manually to $OPENBOX_CONFIG"
                return 1
            }
        
        echo "✓ LXDE/LXQt keyboard shortcut configured successfully!"
        echo "Note: Run 'openbox --reconfigure' or log out and back in for changes to take effect."
        return 0
    else
        echo "Warning: xmlstarlet not found. Manual configuration required."
        echo "Add this to $OPENBOX_CONFIG in the <keyboard> section:"
        echo ""
        echo "  <keybind key=\"W-m\">"
        echo "    <action name=\"Execute\">"
        echo "      <command>$LAUNCH_COMMAND</command>"
        echo "    </action>"
        echo "  </keybind>"
        echo ""
        return 1
    fi
}

# Main setup logic
case "$DE" in
    *xfce*)
        setup_xfce
        ;;
    *gnome*|*unity*|*budgie*)
        setup_gnome
        ;;
    *cinnamon*)
        setup_cinnamon
        ;;
    *mate*)
        setup_mate
        ;;
    *kde*|*plasma*)
        setup_kde
        ;;
    *i3*|*sway*)
        setup_i3
        ;;
    *lxde*|*lxqt*|*openbox*)
        setup_lxde
        ;;
    *)
        echo "Unknown or unsupported desktop environment: $DE"
        echo ""
        echo "Please configure the keyboard shortcut manually:"
        echo "  Shortcut: $SHORTCUT_KEY"
        echo "  Command: $LAUNCH_COMMAND"
        echo ""
        echo "Common locations:"
        echo "  - XFCE: Settings Manager → Keyboard → Application Shortcuts"
        echo "  - GNOME: Settings → Keyboard → Custom Shortcuts"
        echo "  - KDE: System Settings → Shortcuts → Custom Shortcuts"
        echo "  - MATE: System → Preferences → Hardware → Keyboard Shortcuts"
        echo "  - Cinnamon: System Settings → Keyboard → Shortcuts"
        echo "  - i3/Sway: Edit ~/.config/i3/config or ~/.config/sway/config"
        echo "  - LXDE/LXQt: Edit ~/.config/openbox/lxde-rc.xml or rc.xml"
        exit 1
        ;;
esac

echo ""
echo "=================================="
echo "Setup complete! Press Super+M to launch Memo Tori."
echo "=================================="
