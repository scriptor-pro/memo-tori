#!/bin/bash
# Launch Memo Tori with English interface
# This script explicitly sets the language to English

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export MEMO_TORI_LANG=en

exec "$SCRIPT_DIR/.venv/bin/python3" "$SCRIPT_DIR/memo-tori.py" "$@"
