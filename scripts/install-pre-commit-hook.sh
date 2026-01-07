#!/bin/bash
# Install pre-commit hook for Memo Tori
# This script creates a git hook that runs tests before allowing commits

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
HOOK_FILE="$PROJECT_ROOT/.git/hooks/pre-commit"

echo "=================================="
echo "Installing Pre-Commit Hook"
echo "=================================="
echo ""

# Check if .git directory exists
if [ ! -d "$PROJECT_ROOT/.git" ]; then
    echo "❌ Error: .git directory not found"
    echo "This script must be run from a git repository"
    exit 1
fi

# Create hooks directory if it doesn't exist
mkdir -p "$PROJECT_ROOT/.git/hooks"

# Create the pre-commit hook
cat > "$HOOK_FILE" << 'EOF'
#!/bin/bash
# Pre-commit hook for Memo Tori
# Automatically runs tests before allowing a commit

echo ""
echo "🧪 Running tests before commit..."
echo "──────────────────────────────────"

# Find the project root (where .git is)
PROJECT_ROOT="$(git rev-parse --show-toplevel)"

# Check if virtual environment exists
if [ -d "$PROJECT_ROOT/.venv" ]; then
    PYTHON="$PROJECT_ROOT/.venv/bin/python"
    PYTEST="$PROJECT_ROOT/.venv/bin/pytest"
elif [ -d "$PROJECT_ROOT/.venv-test" ]; then
    PYTHON="$PROJECT_ROOT/.venv-test/bin/python"
    PYTEST="$PROJECT_ROOT/.venv-test/bin/pytest"
else
    # Try system pytest
    PYTEST="pytest"
fi

# Check if pytest is available
if ! command -v "$PYTEST" &> /dev/null; then
    echo "⚠️  Warning: pytest not found"
    echo "Install with: pip install -r requirements-dev.txt"
    echo "Skipping tests..."
    exit 0
fi

# Run tests
cd "$PROJECT_ROOT"
$PYTEST --quiet --tb=line

# Check if tests passed
if [ $? -ne 0 ]; then
    echo ""
    echo "❌ Tests failed! Commit aborted."
    echo ""
    echo "Please fix the failing tests and try again."
    echo ""
    echo "💡 Tips:"
    echo "  - Run 'pytest -v' to see detailed test output"
    echo "  - Run 'pytest --lf' to re-run only failed tests"
    echo "  - Use 'git commit --no-verify' to skip this check (not recommended)"
    echo ""
    exit 1
fi

echo ""
echo "✅ All tests passed! Proceeding with commit..."
echo ""
exit 0
EOF

# Make the hook executable
chmod +x "$HOOK_FILE"

echo "✅ Pre-commit hook installed successfully!"
echo ""
echo "Location: .git/hooks/pre-commit"
echo ""
echo "─────────────────────────────────────────────"
echo "What happens now:"
echo "─────────────────────────────────────────────"
echo ""
echo "Every time you run 'git commit':"
echo "  1. Tests will run automatically"
echo "  2. ✅ If tests pass → commit proceeds"
echo "  3. ❌ If tests fail → commit is blocked"
echo ""
echo "To bypass the hook (emergency only):"
echo "  git commit --no-verify -m \"your message\""
echo ""
echo "─────────────────────────────────────────────"
echo "Try it out:"
echo "─────────────────────────────────────────────"
echo ""
echo "  git add ."
echo "  git commit -m \"Add pre-commit hook\""
echo ""
echo "You should see tests run automatically! 🎉"
echo ""
