import os
import sys
from pathlib import Path

import webview

BASE_DIR = Path(__file__).resolve().parent
APP_ID = "memo-tori"


def _resolve_data_dir():
    env_dir = os.environ.get("MEMO_TORI_DATA_DIR")
    if env_dir:
        return Path(env_dir).expanduser()
    if sys.platform.startswith("win"):
        appdata = os.environ.get("APPDATA")
        if appdata:
            return Path(appdata) / APP_ID
        return Path.home() / "AppData" / "Roaming" / APP_ID
    xdg_data_home = os.environ.get("XDG_DATA_HOME")
    if xdg_data_home:
        base_dir = Path(xdg_data_home)
    else:
        base_dir = Path.home() / ".local" / "share"
    return base_dir / APP_ID


DATA_DIR = _resolve_data_dir()
DATA_FILE = DATA_DIR / "ideas.txt"
SEPARATOR = "\n---\n"
MAX_CHARS = 5000


def _load_ideas():
    if not DATA_FILE.exists():
        return []
    text = DATA_FILE.read_text(encoding="utf-8")
    if text == "":
        return []
    return text.split(SEPARATOR)


def _save_ideas(ideas):
    if not DATA_DIR.exists():
        DATA_DIR.mkdir(parents=True, exist_ok=True)
    payload = SEPARATOR.join(ideas)
    DATA_FILE.write_text(payload, encoding="utf-8")


class Api:
    def list_ideas(self):
        ideas = _load_ideas()
        return list(reversed(ideas))

    def save_idea(self, text):
        if text is None:
            return {"ok": False, "error": "empty"}
        if len(text) > MAX_CHARS:
            return {"ok": False, "error": "too_long"}
        if text.strip() == "":
            return {"ok": False, "error": "empty"}
        ideas = _load_ideas()
        ideas.append(text)
        _save_ideas(ideas)
        return {"ok": True}

    def delete_idea(self, index_from_newest):
        ideas = _load_ideas()
        try:
            idx = int(index_from_newest)
        except (TypeError, ValueError):
            return {"ok": False}
        if idx < 0 or idx >= len(ideas):
            return {"ok": False}
        original_index = len(ideas) - 1 - idx
        ideas.pop(original_index)
        _save_ideas(ideas)
        return {"ok": True}


if __name__ == "__main__":
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    html_path = (BASE_DIR / "web" / "index.html").as_uri()
    webview.create_window("Memo Tori", html_path, js_api=Api(), width=700, height=800)
    webview.start()
