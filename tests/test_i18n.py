"""
Unit tests for i18n module (internationalization)
"""
import os
import locale
import pytest
from unittest.mock import patch
import i18n


class TestDetectLanguage:
    """Tests for detect_language() function"""
    
    def test_detect_from_env_variable_en(self, monkeypatch):
        """Should detect English from MEMO_TORI_LANG environment variable"""
        monkeypatch.setenv("MEMO_TORI_LANG", "en")
        assert i18n.detect_language() == "en"
    
    def test_detect_from_env_variable_fr(self, monkeypatch):
        """Should detect French from MEMO_TORI_LANG environment variable"""
        monkeypatch.setenv("MEMO_TORI_LANG", "fr")
        assert i18n.detect_language() == "fr"
    
    def test_detect_from_env_variable_case_insensitive(self, monkeypatch):
        """Should handle case-insensitive environment variable"""
        monkeypatch.setenv("MEMO_TORI_LANG", "EN")
        assert i18n.detect_language() == "en"
        
        monkeypatch.setenv("MEMO_TORI_LANG", "FR")
        assert i18n.detect_language() == "fr"
    
    def test_detect_from_env_variable_with_whitespace(self, monkeypatch):
        """Should strip whitespace from environment variable"""
        monkeypatch.setenv("MEMO_TORI_LANG", "  en  ")
        assert i18n.detect_language() == "en"
    
    def test_invalid_env_variable_falls_back_to_default(self, monkeypatch):
        """Should fall back to default when env variable is invalid"""
        monkeypatch.setenv("MEMO_TORI_LANG", "invalid")
        # Should fall back to system locale or default
        result = i18n.detect_language()
        assert result in i18n.LANGUAGES
    
    @patch('locale.getdefaultlocale')
    def test_detect_from_system_locale_french(self, mock_locale, monkeypatch):
        """Should detect French from system locale"""
        monkeypatch.delenv("MEMO_TORI_LANG", raising=False)
        mock_locale.return_value = ("fr_FR", "UTF-8")
        assert i18n.detect_language() == "fr"
    
    @patch('locale.getdefaultlocale')
    def test_detect_from_system_locale_english(self, mock_locale, monkeypatch):
        """Should detect English from system locale"""
        monkeypatch.delenv("MEMO_TORI_LANG", raising=False)
        mock_locale.return_value = ("en_US", "UTF-8")
        assert i18n.detect_language() == "en"
    
    @patch('locale.getdefaultlocale')
    def test_detect_from_system_locale_variants(self, mock_locale, monkeypatch):
        """Should handle various locale variants"""
        monkeypatch.delenv("MEMO_TORI_LANG", raising=False)
        
        # French variants
        for loc in ["fr_BE", "fr_CA", "fr_CH"]:
            mock_locale.return_value = (loc, "UTF-8")
            assert i18n.detect_language() == "fr"
        
        # English variants
        for loc in ["en_GB", "en_CA", "en_AU"]:
            mock_locale.return_value = (loc, "UTF-8")
            assert i18n.detect_language() == "en"
    
    @patch('locale.getdefaultlocale')
    def test_unsupported_locale_falls_back_to_default(self, mock_locale, monkeypatch):
        """Should fall back to default for unsupported locales"""
        monkeypatch.delenv("MEMO_TORI_LANG", raising=False)
        mock_locale.return_value = ("de_DE", "UTF-8")
        assert i18n.detect_language() == i18n.DEFAULT_LANGUAGE
    
    @patch('locale.getdefaultlocale')
    def test_none_locale_falls_back_to_default(self, mock_locale, monkeypatch):
        """Should fall back to default when locale is None"""
        monkeypatch.delenv("MEMO_TORI_LANG", raising=False)
        mock_locale.return_value = (None, None)
        assert i18n.detect_language() == i18n.DEFAULT_LANGUAGE
    
    @patch('locale.getdefaultlocale')
    def test_locale_error_falls_back_to_default(self, mock_locale, monkeypatch):
        """Should fall back to default when locale raises error"""
        monkeypatch.delenv("MEMO_TORI_LANG", raising=False)
        mock_locale.side_effect = ValueError("Locale error")
        assert i18n.detect_language() == i18n.DEFAULT_LANGUAGE
    
    def test_env_variable_takes_precedence_over_locale(self, monkeypatch):
        """Environment variable should take precedence over system locale"""
        monkeypatch.setenv("MEMO_TORI_LANG", "en")
        with patch('locale.getdefaultlocale', return_value=("fr_FR", "UTF-8")):
            assert i18n.detect_language() == "en"


class TestGetTranslations:
    """Tests for get_translations() function"""
    
    def test_get_english_translations(self):
        """Should return English translations"""
        trans = i18n.get_translations("en")
        assert trans == i18n.TRANSLATIONS["en"]
        assert trans["window_title"] == "Memo Tori"
        assert trans["submit_button"] == "Save this idea"
    
    def test_get_french_translations(self):
        """Should return French translations"""
        trans = i18n.get_translations("fr")
        assert trans == i18n.TRANSLATIONS["fr"]
        assert trans["window_title"] == "Memo Tori"
        assert trans["submit_button"] == "Sauvegarder cette idée"
    
    def test_get_translations_invalid_language_returns_default(self):
        """Should return default translations for invalid language"""
        trans = i18n.get_translations("invalid")
        assert trans == i18n.TRANSLATIONS[i18n.DEFAULT_LANGUAGE]
    
    def test_get_translations_none_autodetects(self, monkeypatch):
        """Should auto-detect language when None is passed"""
        monkeypatch.setenv("MEMO_TORI_LANG", "fr")
        trans = i18n.get_translations(None)
        assert trans == i18n.TRANSLATIONS["fr"]
    
    def test_get_translations_auto_detect(self, monkeypatch):
        """Should auto-detect when called without arguments"""
        monkeypatch.setenv("MEMO_TORI_LANG", "en")
        trans = i18n.get_translations()
        assert trans == i18n.TRANSLATIONS["en"]


class TestTranslate:
    """Tests for translate() and t() functions"""
    
    def test_translate_existing_key_en(self):
        """Should translate existing key in English"""
        result = i18n.translate("submit_button", lang="en")
        assert result == "Save this idea"
    
    def test_translate_existing_key_fr(self):
        """Should translate existing key in French"""
        result = i18n.translate("submit_button", lang="fr")
        assert result == "Sauvegarder cette idée"
    
    def test_translate_missing_key_returns_key(self):
        """Should return the key itself if translation not found"""
        result = i18n.translate("nonexistent_key", lang="en")
        assert result == "nonexistent_key"
    
    def test_translate_with_format_parameters(self):
        """Should format translation with parameters"""
        result = i18n.translate("counter_format", lang="en", count=100, max=5000)
        assert result == "100 / 5000"
        
        result = i18n.translate("counter_format", lang="fr", count=42, max=5000)
        assert result == "42 / 5000"
    
    def test_translate_with_missing_format_params(self):
        """Should handle missing format parameters gracefully"""
        # Should return unformatted string if params are missing
        result = i18n.translate("counter_format", lang="en")
        assert "{count}" in result
        assert "{max}" in result
    
    def test_translate_autodetect_language(self, monkeypatch):
        """Should auto-detect language when not specified"""
        monkeypatch.setenv("MEMO_TORI_LANG", "fr")
        result = i18n.translate("submit_button")
        assert result == "Sauvegarder cette idée"
    
    def test_t_alias_works(self):
        """Should work using the 't' alias"""
        result = i18n.t("submit_button", lang="en")
        assert result == "Save this idea"
        assert i18n.t == i18n.translate


class TestTranslationCompleteness:
    """Tests for translation dictionary completeness"""
    
    def test_all_languages_have_same_keys(self):
        """All language translations should have the same keys"""
        en_keys = set(i18n.TRANSLATIONS["en"].keys())
        fr_keys = set(i18n.TRANSLATIONS["fr"].keys())
        
        assert en_keys == fr_keys, "English and French should have same translation keys"
    
    def test_no_empty_translations(self):
        """No translation should be empty"""
        for lang, translations in i18n.TRANSLATIONS.items():
            for key, value in translations.items():
                assert value, f"Translation '{key}' in '{lang}' should not be empty"
    
    def test_required_keys_present(self):
        """Required translation keys should be present"""
        required_keys = [
            "window_title",
            "textarea_placeholder",
            "counter_format",
            "submit_button",
            "show_list_button",
            "form_error",
            "list_title",
            "new_idea_button",
            "empty_state",
            "delete_label",
            "delete_confirm",
            "html_lang",
        ]
        
        for lang in i18n.LANGUAGES:
            translations = i18n.TRANSLATIONS[lang]
            for key in required_keys:
                assert key in translations, f"Key '{key}' missing in '{lang}' translations"
    
    def test_format_strings_are_consistent(self):
        """Format strings should use same placeholders across languages"""
        counter_en = i18n.TRANSLATIONS["en"]["counter_format"]
        counter_fr = i18n.TRANSLATIONS["fr"]["counter_format"]
        
        # Both should have {count} and {max}
        assert "{count}" in counter_en
        assert "{max}" in counter_en
        assert "{count}" in counter_fr
        assert "{max}" in counter_fr


class TestConstants:
    """Tests for module constants"""
    
    def test_languages_constant(self):
        """LANGUAGES constant should contain supported languages"""
        assert "en" in i18n.LANGUAGES
        assert "fr" in i18n.LANGUAGES
        assert len(i18n.LANGUAGES) >= 2
    
    def test_default_language_is_valid(self):
        """DEFAULT_LANGUAGE should be in LANGUAGES"""
        assert i18n.DEFAULT_LANGUAGE in i18n.LANGUAGES
    
    def test_default_language_is_english(self):
        """Default language should be English"""
        assert i18n.DEFAULT_LANGUAGE == "en"
    
    def test_translations_dict_structure(self):
        """TRANSLATIONS should have correct structure"""
        assert isinstance(i18n.TRANSLATIONS, dict)
        for lang in i18n.LANGUAGES:
            assert lang in i18n.TRANSLATIONS
            assert isinstance(i18n.TRANSLATIONS[lang], dict)
