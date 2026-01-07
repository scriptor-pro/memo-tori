#!/bin/bash
# Build AppImage for Memo Tori

set -e

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Read version
VERSION=$(cat "$PROJECT_DIR/VERSION" | tr -d '\n')

echo "Building AppImage for Memo Tori v$VERSION"

# Create AppDir structure
APPDIR="$PROJECT_DIR/dist/MemoTori.AppDir"
rm -rf "$APPDIR"
mkdir -p "$APPDIR"

# Create directory structure
mkdir -p "$APPDIR/usr/bin"
mkdir -p "$APPDIR/usr/lib/memo-tori"
mkdir -p "$APPDIR/usr/share/applications"
mkdir -p "$APPDIR/usr/share/pixmaps"

# Copy application files
cp "$PROJECT_DIR/memo-tori.py" "$APPDIR/usr/lib/memo-tori/"
cp "$PROJECT_DIR/i18n.py" "$APPDIR/usr/lib/memo-tori/"
cp -r "$PROJECT_DIR/web" "$APPDIR/usr/lib/memo-tori/"

# Install dependencies into AppDir
echo "Installing Python dependencies..."
mkdir -p "$APPDIR/usr/lib/memo-tori/lib"
pip3 install --target "$APPDIR/usr/lib/memo-tori/lib" pywebview --quiet

# Copy icon
cp "$PROJECT_DIR/assets/icon.png" "$APPDIR/usr/share/pixmaps/memo-tori.png"
cp "$PROJECT_DIR/assets/icon.png" "$APPDIR/memo-tori.png"

# Create launcher script
cat > "$APPDIR/usr/bin/memo-tori" << 'EOF'
#!/bin/bash
# Memo Tori AppImage launcher

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_DIR="$(dirname "$SCRIPT_DIR")/lib/memo-tori"

# Set PYTHONPATH to include our app directory and bundled libs
export PYTHONPATH="$APP_DIR:$APP_DIR/lib:$PYTHONPATH"

# Change to app directory and run
cd "$APP_DIR"
exec python3 memo-tori.py "$@"
EOF
chmod +x "$APPDIR/usr/bin/memo-tori"

# Create AppRun
cat > "$APPDIR/AppRun" << 'EOF'
#!/bin/bash
# AppImage entry point for Memo Tori

# Get the directory where this AppImage is mounted
APPDIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

# Set up environment
export PATH="$APPDIR/usr/bin:$PATH"
export PYTHONPATH="$APPDIR/usr/lib/memo-tori:$APPDIR/usr/lib/memo-tori/lib:$PYTHONPATH"

# Check if Python 3 is available
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is required but not found"
    echo "Please install Python 3 to use Memo Tori"
    exit 1
fi

# Run the application
cd "$APPDIR/usr/lib/memo-tori"
exec python3 memo-tori.py "$@"
EOF
chmod +x "$APPDIR/AppRun"

# Create desktop file
cat > "$APPDIR/memo-tori.desktop" << EOF
[Desktop Entry]
Type=Application
Name=Memo Tori
Comment=Capture a single idea locally
Exec=memo-tori
Icon=memo-tori
Terminal=false
Categories=Utility;Office;
StartupWMClass=Memo Tori
EOF

# Copy desktop file to applications directory
cp "$APPDIR/memo-tori.desktop" "$APPDIR/usr/share/applications/"

# Download appimagetool if not available
if [ ! -f "/tmp/appimagetool" ]; then
    echo "Downloading AppImage tools..."
    wget -q https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage -O /tmp/appimagetool
    chmod +x /tmp/appimagetool
fi

# Build the AppImage
echo "Building AppImage..."
OUTPUT_DIR="$PROJECT_DIR/dist"
cd "$OUTPUT_DIR"

# Create AppImage
ARCH=x86_64 /tmp/appimagetool MemoTori.AppDir "memo-tori-${VERSION}-x86_64.AppImage"

echo "AppImage built successfully: $OUTPUT_DIR/memo-tori-${VERSION}-x86_64.AppImage"
echo ""
echo "You can now run: ./dist/memo-tori-${VERSION}-x86_64.AppImage"
echo ""
echo "Note: This AppImage requires:"
echo "- Python 3.10+"
echo "- pywebview package"
echo "- GTK3 and WebKit2 system libraries"