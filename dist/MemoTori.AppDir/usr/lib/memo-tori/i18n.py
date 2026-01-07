"""
Internationalization (i18n) module for Memo Tori.

Supports English (en) and French (fr) locales.
Language is determined by:
1. MEMO_TORI_LANG environment variable (e.g., 'en' or 'fr')
2. System locale (e.g., fr_FR -> 'fr', en_US -> 'en')
3. Default fallback to English
"""

import os
import locale

# Available languages
LANGUAGES = ["en", "fr"]
DEFAULT_LANGUAGE = "en"

# Translation dictionaries
TRANSLATIONS = {
    "en": {
        # Window title
        "window_title": "Memo Tori",
        
        # Form view
        "textarea_placeholder": "Your idea:",
        "counter_format": "{count} / {max}",
        "submit_button": "Save this idea",
        "show_list_button": "Ideas list",
        "form_error": "Unable to save this idea.",
        
        # List view
        "list_title": "Ideas",
        "new_idea_button": "I have a new idea",
        "empty_state": "No ideas yet.",
        "delete_label": "delete",
        "delete_confirm": "Delete this idea?",
        
        # HTML meta
        "html_lang": "en",
    },
    "fr": {
        # Window title
        "window_title": "Memo Tori",
        
        # Form view
        "textarea_placeholder": "Ton idée :",
        "counter_format": "{count} / {max}",
        "submit_button": "Sauvegarder cette idée",
        "show_list_button": "Liste des idées",
        "form_error": "Impossible d'enregistrer cette idée.",
        
        # List view
        "list_title": "Idées",
        "new_idea_button": "J'ai une nouvelle idée",
        "empty_state": "Aucune idée pour le moment.",
        "delete_label": "effacer",
        "delete_confirm": "Effacer cette idée ?",
        
        # HTML meta
        "html_lang": "fr",
    }
}


def detect_language():
    """
    Detect the user's preferred language.
    
    Returns:
        str: Language code ('en' or 'fr')
    """
    # Check environment variable first
    env_lang = os.environ.get("MEMO_TORI_LANG", "").lower().strip()
    if env_lang in LANGUAGES:
        return env_lang
    
    # Try to detect from system locale
    try:
        system_locale, _ = locale.getdefaultlocale()
        if system_locale:
            # Extract language code (e.g., 'fr_FR' -> 'fr')
            lang_code = system_locale.split('_')[0].lower()
            if lang_code in LANGUAGES:
                return lang_code
    except (ValueError, AttributeError):
        pass
    
    # Fallback to default
    return DEFAULT_LANGUAGE


def get_translations(lang=None):
    """
    Get translations for the specified language.
    
    Args:
        lang (str, optional): Language code. If None, auto-detect.
    
    Returns:
        dict: Translation dictionary
    """
    if lang is None:
        lang = detect_language()
    
    return TRANSLATIONS.get(lang, TRANSLATIONS[DEFAULT_LANGUAGE])


def translate(key, lang=None, **kwargs):
    """
    Translate a single key.
    
    Args:
        key (str): Translation key
        lang (str, optional): Language code. If None, auto-detect.
        **kwargs: Format parameters for the translation string
    
    Returns:
        str: Translated string
    """
    translations = get_translations(lang)
    text = translations.get(key, key)
    
    if kwargs:
        try:
            return text.format(**kwargs)
        except (KeyError, ValueError):
            return text
    
    return text


# Convenience alias
t = translate
