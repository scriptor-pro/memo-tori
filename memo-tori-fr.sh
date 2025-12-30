#!/bin/bash
# Launch Memo Tori with French interface
# This script explicitly sets the language to French

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export MEMO_TORI_LANG=fr

exec "$SCRIPT_DIR/.venv/bin/python3" "$SCRIPT_DIR/memo-tori.py" "$@"
