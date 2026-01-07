"""
Unit tests for Api class methods
"""
import tempfile
from pathlib import Path
import pytest
from unittest.mock import patch, MagicMock

import sys
from pathlib import Path

# Add parent directory to path to import memo-tori.py
sys.path.insert(0, str(Path(__file__).parent.parent))
import importlib.util
spec = importlib.util.spec_from_file_location("memo_tori", "memo-tori.py")
memo_tori = importlib.util.module_from_spec(spec)
spec.loader.exec_module(memo_tori)


class TestApiListIdeas:
    """Tests for Api.list_ideas() method"""
    
    def test_list_ideas_empty(self, tmp_path, monkeypatch):
        """Should return empty list when no ideas exist"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        api = memo_tori.Api()
        result = api.list_ideas()
        
        assert result == []
    
    def test_list_ideas_single_idea(self, tmp_path, monkeypatch):
        """Should return single idea"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        data_dir.mkdir()
        data_file.write_text("My idea", encoding="utf-8")
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        api = memo_tori.Api()
        result = api.list_ideas()
        
        assert result == ["My idea"]
    
    def test_list_ideas_returns_newest_first(self, tmp_path, monkeypatch):
        """Should return ideas in reverse order (newest first)"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        data_dir.mkdir()
        data_file.write_text("First\n---\nSecond\n---\nThird", encoding="utf-8")
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        api = memo_tori.Api()
        result = api.list_ideas()
        
        # Should be reversed: newest (Third) first
        assert result == ["Third", "Second", "First"]
    
    def test_list_ideas_multiple(self, tmp_path, monkeypatch):
        """Should return all ideas in reverse order"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        data_dir.mkdir()
        
        ideas = ["Alpha", "Beta", "Gamma", "Delta"]
        content = "\n---\n".join(ideas)
        data_file.write_text(content, encoding="utf-8")
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        api = memo_tori.Api()
        result = api.list_ideas()
        
        # Should be reversed
        assert result == ["Delta", "Gamma", "Beta", "Alpha"]


class TestApiSaveIdea:
    """Tests for Api.save_idea() method"""
    
    def test_save_idea_success(self, tmp_path, monkeypatch):
        """Should save idea and return success"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        api = memo_tori.Api()
        result = api.save_idea("My new idea")
        
        assert result == {"ok": True}
        assert data_file.exists()
        assert data_file.read_text(encoding="utf-8") == "My new idea"
    
    def test_save_idea_appends_to_existing(self, tmp_path, monkeypatch):
        """Should append new idea to existing ideas"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        data_dir.mkdir()
        data_file.write_text("Existing idea", encoding="utf-8")
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        api = memo_tori.Api()
        result = api.save_idea("New idea")
        
        assert result == {"ok": True}
        content = data_file.read_text(encoding="utf-8")
        assert content == "Existing idea\n---\nNew idea"
    
    def test_save_idea_rejects_none(self, tmp_path, monkeypatch):
        """Should reject None as empty"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        api = memo_tori.Api()
        result = api.save_idea(None)
        
        assert result == {"ok": False, "error": "empty"}
        assert not data_file.exists()
    
    def test_save_idea_rejects_empty_string(self, tmp_path, monkeypatch):
        """Should reject empty string"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        api = memo_tori.Api()
        result = api.save_idea("")
        
        assert result == {"ok": False, "error": "empty"}
        assert not data_file.exists()
    
    def test_save_idea_rejects_whitespace_only(self, tmp_path, monkeypatch):
        """Should reject whitespace-only strings"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        api = memo_tori.Api()
        
        for text in ["   ", "\t\t", "\n\n", "  \t\n  "]:
            result = api.save_idea(text)
            assert result == {"ok": False, "error": "empty"}
            assert not data_file.exists()
    
    def test_save_idea_rejects_too_long(self, tmp_path, monkeypatch):
        """Should reject ideas exceeding MAX_CHARS"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        api = memo_tori.Api()
        # Create a string longer than MAX_CHARS (5000)
        long_text = "a" * (memo_tori.MAX_CHARS + 1)
        result = api.save_idea(long_text)
        
        assert result == {"ok": False, "error": "too_long"}
        assert not data_file.exists()
    
    def test_save_idea_accepts_at_max_chars(self, tmp_path, monkeypatch):
        """Should accept idea exactly at MAX_CHARS"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        api = memo_tori.Api()
        # Create a string exactly MAX_CHARS long
        exact_text = "a" * memo_tori.MAX_CHARS
        result = api.save_idea(exact_text)
        
        assert result == {"ok": True}
        assert data_file.exists()
    
    def test_save_idea_preserves_newlines(self, tmp_path, monkeypatch):
        """Should preserve newlines in saved ideas"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        api = memo_tori.Api()
        text = "Line 1\nLine 2\nLine 3"
        result = api.save_idea(text)
        
        assert result == {"ok": True}
        content = data_file.read_text(encoding="utf-8")
        assert content == text
    
    def test_save_idea_handles_special_characters(self, tmp_path, monkeypatch):
        """Should handle special characters correctly"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        api = memo_tori.Api()
        text = "Idée avec accénts 日本語 🎉"
        result = api.save_idea(text)
        
        assert result == {"ok": True}
        content = data_file.read_text(encoding="utf-8")
        assert text in content


class TestApiDeleteIdea:
    """Tests for Api.delete_idea() method"""
    
    def test_delete_idea_success(self, tmp_path, monkeypatch):
        """Should delete idea and return success"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        data_dir.mkdir()
        data_file.write_text("First\n---\nSecond\n---\nThird", encoding="utf-8")
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        api = memo_tori.Api()
        # Delete index 0 (which is "Third" - the newest)
        result = api.delete_idea(0)
        
        assert result == {"ok": True}
        content = data_file.read_text(encoding="utf-8")
        assert content == "First\n---\nSecond"
    
    def test_delete_idea_deletes_correct_item(self, tmp_path, monkeypatch):
        """Should delete the correct idea by index from newest"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        data_dir.mkdir()
        data_file.write_text("Alpha\n---\nBeta\n---\nGamma", encoding="utf-8")
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        api = memo_tori.Api()
        # Delete index 1 from newest (which is "Beta")
        result = api.delete_idea(1)
        
        assert result == {"ok": True}
        content = data_file.read_text(encoding="utf-8")
        assert content == "Alpha\n---\nGamma"
        assert "Beta" not in content
    
    def test_delete_idea_last_item(self, tmp_path, monkeypatch):
        """Should delete the last (oldest) idea"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        data_dir.mkdir()
        data_file.write_text("First\n---\nSecond\n---\nThird", encoding="utf-8")
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        api = memo_tori.Api()
        # Delete index 2 from newest (which is "First" - the oldest)
        result = api.delete_idea(2)
        
        assert result == {"ok": True}
        content = data_file.read_text(encoding="utf-8")
        assert content == "Second\n---\nThird"
        assert "First" not in content
    
    def test_delete_idea_only_item(self, tmp_path, monkeypatch):
        """Should delete the only idea, leaving empty file"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        data_dir.mkdir()
        data_file.write_text("Only idea", encoding="utf-8")
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        api = memo_tori.Api()
        result = api.delete_idea(0)
        
        assert result == {"ok": True}
        content = data_file.read_text(encoding="utf-8")
        assert content == ""
    
    def test_delete_idea_rejects_negative_index(self, tmp_path, monkeypatch):
        """Should reject negative indices"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        data_dir.mkdir()
        data_file.write_text("Idea", encoding="utf-8")
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        api = memo_tori.Api()
        result = api.delete_idea(-1)
        
        assert result == {"ok": False}
        # Idea should still exist
        assert data_file.read_text(encoding="utf-8") == "Idea"
    
    def test_delete_idea_rejects_out_of_bounds(self, tmp_path, monkeypatch):
        """Should reject index >= number of ideas"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        data_dir.mkdir()
        data_file.write_text("First\n---\nSecond", encoding="utf-8")
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        api = memo_tori.Api()
        result = api.delete_idea(2)  # Only 2 ideas (indices 0 and 1)
        
        assert result == {"ok": False}
        # Ideas should still exist
        content = data_file.read_text(encoding="utf-8")
        assert "First" in content
        assert "Second" in content
    
    def test_delete_idea_rejects_non_integer_string(self, tmp_path, monkeypatch):
        """Should reject non-integer string indices"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        data_dir.mkdir()
        data_file.write_text("Idea", encoding="utf-8")
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        api = memo_tori.Api()
        result = api.delete_idea("not_a_number")
        
        assert result == {"ok": False}
        assert data_file.read_text(encoding="utf-8") == "Idea"
    
    def test_delete_idea_accepts_string_integer(self, tmp_path, monkeypatch):
        """Should accept string representation of integer"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        data_dir.mkdir()
        data_file.write_text("First\n---\nSecond", encoding="utf-8")
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        api = memo_tori.Api()
        result = api.delete_idea("0")  # String "0"
        
        assert result == {"ok": True}
        content = data_file.read_text(encoding="utf-8")
        assert content == "First"


class TestApiGetTranslations:
    """Tests for Api.get_translations() method"""
    
    def test_get_translations_returns_dict(self):
        """Should return translations dictionary"""
        api = memo_tori.Api()
        result = api.get_translations()
        
        assert isinstance(result, dict)
    
    def test_get_translations_returns_current_language(self, monkeypatch):
        """Should return translations for current language"""
        # This test verifies the method returns the TRANSLATIONS dict
        # The language is determined at module load time, so we just verify
        # that get_translations() returns the correct structure
        api = memo_tori.Api()
        result = api.get_translations()
        
        # Should have all required translation keys
        assert "submit_button" in result
        assert isinstance(result["submit_button"], str)
        # Verify it matches the module's TRANSLATIONS
        assert result == memo_tori.TRANSLATIONS
    
    def test_get_translations_has_required_keys(self):
        """Should have all required translation keys"""
        api = memo_tori.Api()
        result = api.get_translations()
        
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
        
        for key in required_keys:
            assert key in result, f"Missing required key: {key}"


class TestApiIntegration:
    """Integration tests for Api class"""
    
    def test_full_workflow(self, tmp_path, monkeypatch):
        """Test complete workflow: save, list, delete"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        api = memo_tori.Api()
        
        # Start with empty list
        assert api.list_ideas() == []
        
        # Save first idea
        result = api.save_idea("First idea")
        assert result["ok"] is True
        
        # List should show it (newest first)
        ideas = api.list_ideas()
        assert ideas == ["First idea"]
        
        # Save second idea
        result = api.save_idea("Second idea")
        assert result["ok"] is True
        
        # List should show both (newest first)
        ideas = api.list_ideas()
        assert ideas == ["Second idea", "First idea"]
        
        # Save third idea
        result = api.save_idea("Third idea")
        assert result["ok"] is True
        
        # List should show all three
        ideas = api.list_ideas()
        assert ideas == ["Third idea", "Second idea", "First idea"]
        
        # Delete the middle one (index 1 from newest = "Second idea")
        result = api.delete_idea(1)
        assert result["ok"] is True
        
        # List should show remaining two
        ideas = api.list_ideas()
        assert ideas == ["Third idea", "First idea"]
        
        # Delete first one (index 0 = "Third idea")
        result = api.delete_idea(0)
        assert result["ok"] is True
        
        # List should show only one
        ideas = api.list_ideas()
        assert ideas == ["First idea"]
        
        # Delete last one
        result = api.delete_idea(0)
        assert result["ok"] is True
        
        # List should be empty
        ideas = api.list_ideas()
        assert ideas == []
