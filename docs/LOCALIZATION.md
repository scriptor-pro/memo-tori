# Localization Guide

Memo Tori supports multiple languages through an environment variable-based localization system.

## Supported Languages

- **English (en)** - Default fallback language
- **French (fr)** - Full translation available

## Language Detection

The application automatically detects the language in the following order:

1. **MEMO_TORI_LANG environment variable** - Explicitly set language (e.g., `en` or `fr`)
2. **System locale** - Detected from your operating system (e.g., `fr_FR` → French)
3. **Default fallback** - English if no language can be detected

## Using a Specific Language

### Method 1: Environment Variable (Temporary)

Set the language before launching:

**English:**
```bash
export MEMO_TORI_LANG=en
python3 memo-tori.py
```

**French:**
```bash
export MEMO_TORI_LANG=fr
python3 memo-tori.py
```

### Method 2: Language-Specific Launchers

Use the provided launcher scripts:

**English:**
```bash
bash memo-tori-en.sh
```

**French:**
```bash
bash memo-tori-fr.sh
```

### Method 3: Desktop Integration

Copy the language-specific desktop files to your applications directory:

**English version:**
```bash
cp memo-tori-en.desktop ~/.local/share/applications/
```

**French version:**
```bash
cp memo-tori-fr.desktop ~/.local/share/applications/
```

Both versions will appear separately in your application launcher.

### Method 4: Permanent Environment Variable

Add to your `~/.bashrc` or `~/.zshrc`:

```bash
export MEMO_TORI_LANG=en  # or fr
```

Then restart your terminal or run:
```bash
source ~/.bashrc
```

## Keyboard Shortcuts for Language Versions

You can set up different keyboard shortcuts for each language version:

**For English:**
```bash
# Modify LAUNCH_COMMAND in the setup script to use memo-tori-en.sh
bash scripts/setup-keyboard-shortcut.sh
```

Or manually configure:
- Command: `/path/to/memo-tori-en.sh`
- Shortcut: `Super+M` (or your preference)

**For French:**
- Command: `/path/to/memo-tori-fr.sh`
- Shortcut: `Super+Shift+M` (or your preference)

## How It Works

### Architecture

1. **Backend (Python)**: `i18n.py` module handles language detection and provides translations
2. **Frontend (JavaScript)**: Loads translations from the backend on startup
3. **Automatic**: No manual configuration needed in most cases

### Translation Files

All translations are stored in `i18n.py` in the `TRANSLATIONS` dictionary:

```python
TRANSLATIONS = {
    "en": {
        "window_title": "Memo Tori",
        "submit_button": "Save this idea",
        # ... more translations
    },
    "fr": {
        "window_title": "Memo Tori",
        "submit_button": "Sauvegarder cette idée",
        # ... more translations
    }
}
```

### Translation Keys

| Key | English | French | Usage |
|-----|---------|--------|-------|
| `window_title` | Memo Tori | Memo Tori | Application window title |
| `textarea_placeholder` | Your idea: | Ton idée : | Text input placeholder |
| `counter_format` | {count} / {max} | {count} / {max} | Character counter |
| `submit_button` | Save this idea | Sauvegarder cette idée | Submit button |
| `show_list_button` | Ideas list | Liste des idées | Show list button |
| `form_error` | Unable to save this idea. | Impossible d'enregistrer cette idée. | Error message |
| `list_title` | Ideas | Idées | List view heading |
| `new_idea_button` | I have a new idea | J'ai une nouvelle idée | Return to form button |
| `empty_state` | No ideas yet. | Aucune idée pour le moment. | Empty list message |
| `delete_label` | delete | effacer | Delete checkbox label |
| `delete_confirm` | Delete this idea? | Effacer cette idée ? | Delete confirmation |
| `html_lang` | en | fr | HTML lang attribute |

## Testing Different Languages

### Quick Test

**Test English:**
```bash
MEMO_TORI_LANG=en python3 memo-tori.py
```

**Test French:**
```bash
MEMO_TORI_LANG=fr python3 memo-tori.py
```

### Verify Language Detection

Check what language will be used:

```python
python3 -c "from i18n import detect_language; print(f'Detected language: {detect_language()}')"
```

## Adding a New Language

To add support for a new language (e.g., Spanish):

### Step 1: Add Language Code

Edit `i18n.py`:

```python
LANGUAGES = ["en", "fr", "es"]  # Add "es"
```

### Step 2: Add Translations

Add the translation dictionary:

```python
TRANSLATIONS = {
    "en": { ... },
    "fr": { ... },
    "es": {
        "window_title": "Memo Tori",
        "textarea_placeholder": "Tu idea:",
        "submit_button": "Guardar esta idea",
        # ... add all translation keys
    }
}
```

### Step 3: Create Launcher (Optional)

Create `memo-tori-es.sh`:

```bash
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export MEMO_TORI_LANG=es
exec "$SCRIPT_DIR/.venv/bin/python3" "$SCRIPT_DIR/memo-tori.py" "$@"
```

### Step 4: Create Desktop Entry (Optional)

Create `memo-tori-es.desktop` with Spanish metadata.

### Step 5: Test

```bash
MEMO_TORI_LANG=es python3 memo-tori.py
```

## Troubleshooting

### Problem: Wrong language displayed

**Check environment variable:**
```bash
echo $MEMO_TORI_LANG
```

**Unset if needed:**
```bash
unset MEMO_TORI_LANG
```

**Check system locale:**
```bash
locale
```

### Problem: Language doesn't change

**Solution**: Make sure you're setting the variable before launching:

```bash
# This works:
MEMO_TORI_LANG=en python3 memo-tori.py

# This doesn't work (variable set in a different shell):
export MEMO_TORI_LANG=en
# ... close terminal, open new one
python3 memo-tori.py  # Variable is gone
```

To make it permanent, add to `~/.bashrc`.

### Problem: Translations not loading in frontend

**Check browser console** (if using debug mode):
- Open developer tools
- Look for "Failed to load translations" errors
- Verify that `window.pywebview.api.get_translations()` is available

### Problem: Mixed language text

**Cause**: Fallback to English for missing translation keys.

**Solution**: Check that all keys exist in `i18n.py` for your language.

## Data Storage

**Important**: The data storage location is the same regardless of language. All language versions share the same ideas file:

- Linux: `~/.local/share/memo-tori/ideas.txt`
- Windows: `%APPDATA%\memo-tori\ideas.txt`

This means you can switch languages and still see all your ideas.

## Best Practices

1. **System Language**: Most users should rely on automatic detection
2. **Power Users**: Set `MEMO_TORI_LANG` in shell config for consistent language
3. **Desktop Integration**: Use language-specific `.desktop` files for clarity
4. **Testing**: Always test both languages when making changes

---

**Last updated**: 2025-12-29
