"""
Unit tests for storage functions (_load_ideas, _save_ideas)
"""
import os
import tempfile
from pathlib import Path
import pytest
from unittest.mock import patch, MagicMock

# Import the functions we need to test
import sys
from pathlib import Path

# Add parent directory to path to import memo-tori.py
sys.path.insert(0, str(Path(__file__).parent.parent))
import importlib.util
spec = importlib.util.spec_from_file_location("memo_tori", "memo-tori.py")
memo_tori = importlib.util.module_from_spec(spec)
spec.loader.exec_module(memo_tori)


class TestResolveDataDir:
    """Tests for _resolve_data_dir() function"""
    
    def test_uses_env_variable_when_set(self, monkeypatch, tmp_path):
        """Should use MEMO_TORI_DATA_DIR environment variable when set"""
        test_dir = tmp_path / "custom_data"
        monkeypatch.setenv("MEMO_TORI_DATA_DIR", str(test_dir))
        
        result = memo_tori._resolve_data_dir()
        assert result == test_dir
    
    def test_expands_home_directory_in_env_var(self, monkeypatch):
        """Should expand ~ in MEMO_TORI_DATA_DIR"""
        monkeypatch.setenv("MEMO_TORI_DATA_DIR", "~/custom_memo_data")
        
        result = memo_tori._resolve_data_dir()
        assert "~" not in str(result)
        assert result == Path.home() / "custom_memo_data"
    
    @patch('sys.platform', 'win32')
    def test_windows_appdata_path(self, monkeypatch):
        """Should use %APPDATA% on Windows"""
        monkeypatch.delenv("MEMO_TORI_DATA_DIR", raising=False)
        monkeypatch.setenv("APPDATA", "C:\\Users\\Test\\AppData\\Roaming")
        
        result = memo_tori._resolve_data_dir()
        # Check that the result contains the expected path components
        result_str = str(result)
        assert result_str.endswith("memo-tori")
        assert "AppData" in result_str
        assert "Roaming" in result_str
    
    @patch('sys.platform', 'win32')
    def test_windows_fallback_when_no_appdata(self, monkeypatch):
        """Should fall back to Home/AppData/Roaming on Windows if APPDATA not set"""
        monkeypatch.delenv("MEMO_TORI_DATA_DIR", raising=False)
        monkeypatch.delenv("APPDATA", raising=False)
        
        result = memo_tori._resolve_data_dir()
        assert result == Path.home() / "AppData" / "Roaming" / "memo-tori"
    
    @patch('sys.platform', 'linux')
    def test_linux_xdg_data_home(self, monkeypatch, tmp_path):
        """Should use XDG_DATA_HOME on Linux when set"""
        monkeypatch.delenv("MEMO_TORI_DATA_DIR", raising=False)
        xdg_dir = tmp_path / "xdg_data"
        monkeypatch.setenv("XDG_DATA_HOME", str(xdg_dir))
        
        result = memo_tori._resolve_data_dir()
        assert result == xdg_dir / "memo-tori"
    
    @patch('sys.platform', 'linux')
    def test_linux_default_path(self, monkeypatch):
        """Should use ~/.local/share on Linux when XDG_DATA_HOME not set"""
        monkeypatch.delenv("MEMO_TORI_DATA_DIR", raising=False)
        monkeypatch.delenv("XDG_DATA_HOME", raising=False)
        
        result = memo_tori._resolve_data_dir()
        assert result == Path.home() / ".local" / "share" / "memo-tori"


class TestLoadIdeas:
    """Tests for _load_ideas() function"""
    
    def test_load_empty_file_returns_empty_list(self, tmp_path, monkeypatch):
        """Should return empty list for empty file"""
        data_file = tmp_path / "ideas.txt"
        data_file.write_text("", encoding="utf-8")
        
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        result = memo_tori._load_ideas()
        assert result == []
    
    def test_load_nonexistent_file_returns_empty_list(self, tmp_path, monkeypatch):
        """Should return empty list when file doesn't exist"""
        data_file = tmp_path / "nonexistent.txt"
        
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        result = memo_tori._load_ideas()
        assert result == []
    
    def test_load_single_idea(self, tmp_path, monkeypatch):
        """Should load a single idea"""
        data_file = tmp_path / "ideas.txt"
        data_file.write_text("My first idea", encoding="utf-8")
        
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        result = memo_tori._load_ideas()
        assert result == ["My first idea"]
    
    def test_load_multiple_ideas(self, tmp_path, monkeypatch):
        """Should load multiple ideas separated by ---"""
        content = "First idea\n---\nSecond idea\n---\nThird idea"
        data_file = tmp_path / "ideas.txt"
        data_file.write_text(content, encoding="utf-8")
        
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        result = memo_tori._load_ideas()
        assert result == ["First idea", "Second idea", "Third idea"]
    
    def test_load_ideas_with_newlines(self, tmp_path, monkeypatch):
        """Should preserve newlines within ideas"""
        content = "Idea with\nmultiple\nlines\n---\nAnother idea"
        data_file = tmp_path / "ideas.txt"
        data_file.write_text(content, encoding="utf-8")
        
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        result = memo_tori._load_ideas()
        assert result == ["Idea with\nmultiple\nlines", "Another idea"]
    
    def test_load_ideas_with_special_characters(self, tmp_path, monkeypatch):
        """Should handle special characters correctly"""
        content = "Idée avec accénts\n---\n日本語\n---\nEmojis 🎉🎊"
        data_file = tmp_path / "ideas.txt"
        data_file.write_text(content, encoding="utf-8")
        
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        result = memo_tori._load_ideas()
        assert result == ["Idée avec accénts", "日本語", "Emojis 🎉🎊"]
    
    def test_load_ideas_preserves_whitespace(self, tmp_path, monkeypatch):
        """Should preserve leading/trailing whitespace in ideas"""
        content = "  Idea with spaces  \n---\n\tTabbed idea\t"
        data_file = tmp_path / "ideas.txt"
        data_file.write_text(content, encoding="utf-8")
        
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        result = memo_tori._load_ideas()
        assert result == ["  Idea with spaces  ", "\tTabbed idea\t"]


class TestSaveIdeas:
    """Tests for _save_ideas() function"""
    
    def test_save_empty_list(self, tmp_path, monkeypatch):
        """Should save empty list as empty file"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        memo_tori._save_ideas([])
        
        assert data_file.exists()
        assert data_file.read_text(encoding="utf-8") == ""
    
    def test_save_single_idea(self, tmp_path, monkeypatch):
        """Should save a single idea"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        memo_tori._save_ideas(["My first idea"])
        
        content = data_file.read_text(encoding="utf-8")
        assert content == "My first idea"
    
    def test_save_multiple_ideas(self, tmp_path, monkeypatch):
        """Should save multiple ideas with separator"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        ideas = ["First idea", "Second idea", "Third idea"]
        memo_tori._save_ideas(ideas)
        
        content = data_file.read_text(encoding="utf-8")
        assert content == "First idea\n---\nSecond idea\n---\nThird idea"
    
    def test_save_ideas_with_newlines(self, tmp_path, monkeypatch):
        """Should preserve newlines within ideas"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        ideas = ["Idea with\nmultiple\nlines", "Another idea"]
        memo_tori._save_ideas(ideas)
        
        content = data_file.read_text(encoding="utf-8")
        assert content == "Idea with\nmultiple\nlines\n---\nAnother idea"
    
    def test_save_creates_directory_if_not_exists(self, tmp_path, monkeypatch):
        """Should create data directory if it doesn't exist"""
        data_dir = tmp_path / "new_dir" / "nested"
        data_file = data_dir / "ideas.txt"
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        assert not data_dir.exists()
        
        memo_tori._save_ideas(["Test idea"])
        
        assert data_dir.exists()
        assert data_file.exists()
    
    def test_save_overwrites_existing_file(self, tmp_path, monkeypatch):
        """Should overwrite existing file"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        data_dir.mkdir()
        data_file.write_text("Old content", encoding="utf-8")
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        memo_tori._save_ideas(["New idea"])
        
        content = data_file.read_text(encoding="utf-8")
        assert content == "New idea"
        assert "Old content" not in content
    
    def test_save_ideas_with_special_characters(self, tmp_path, monkeypatch):
        """Should handle special characters correctly"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        ideas = ["Idée avec accénts", "日本語", "Emojis 🎉🎊"]
        memo_tori._save_ideas(ideas)
        
        content = data_file.read_text(encoding="utf-8")
        assert "Idée avec accénts" in content
        assert "日本語" in content
        assert "🎉🎊" in content


class TestRoundTrip:
    """Tests for save/load round-trip consistency"""
    
    def test_roundtrip_single_idea(self, tmp_path, monkeypatch):
        """Should preserve single idea through save/load cycle"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        original = ["My test idea"]
        memo_tori._save_ideas(original)
        loaded = memo_tori._load_ideas()
        
        assert loaded == original
    
    def test_roundtrip_multiple_ideas(self, tmp_path, monkeypatch):
        """Should preserve multiple ideas through save/load cycle"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        original = ["First idea", "Second idea", "Third idea"]
        memo_tori._save_ideas(original)
        loaded = memo_tori._load_ideas()
        
        assert loaded == original
    
    def test_roundtrip_with_newlines(self, tmp_path, monkeypatch):
        """Should preserve newlines through save/load cycle"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        original = ["Idea\nwith\nnewlines", "Another\nidea"]
        memo_tori._save_ideas(original)
        loaded = memo_tori._load_ideas()
        
        assert loaded == original
    
    def test_roundtrip_preserves_order(self, tmp_path, monkeypatch):
        """Should preserve order of ideas through save/load cycle"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        original = ["Alpha", "Beta", "Gamma", "Delta", "Epsilon"]
        memo_tori._save_ideas(original)
        loaded = memo_tori._load_ideas()
        
        assert loaded == original
    
    def test_roundtrip_empty_list(self, tmp_path, monkeypatch):
        """Should handle empty list through save/load cycle"""
        data_dir = tmp_path / "data"
        data_file = data_dir / "ideas.txt"
        
        monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
        monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
        
        original = []
        memo_tori._save_ideas(original)
        loaded = memo_tori._load_ideas()
        
        assert loaded == original
