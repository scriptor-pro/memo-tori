# Memo Tori

Memo Tori is a tiny Linux desktop app to capture a single idea and store it locally as plain text.

## What it does

- One text field (up to 5000 characters)
- Save the idea to a local file
- View the full list of ideas (newest first)
- Delete ideas with a confirmation

No editing, no search, no metadata, no sync.

## Tech

- Python + pywebview (GTK on Linux)
- Embedded HTML/CSS/JS (no frontend framework)
- Storage: UTF-8 plain text with `---` separators

## Requirements (MX Linux 23 / Debian 12)

System packages:

```bash
sudo apt update
sudo apt install -y python3-venv python3-pip python3-gi gir1.2-gtk-3.0 gir1.2-webkit2-4.0
```

## Install

```bash
cd /home/Baudouin/Documents/Projets/Memo-Tori
python3 -m venv --system-site-packages .venv
. .venv/bin/activate
pip install -r requirements.txt
```

If your system `python3` is not Debian's 3.11, use it explicitly:

```bash
/usr/bin/python3.11 -m venv --system-site-packages .venv
```

## Run

```bash
cd /home/Baudouin/Documents/Projets/Memo-Tori
. .venv/bin/activate
python3 app.py
```

## Data format

Ideas are stored in `data/ideas.txt` using plain text blocks separated by a line containing:

```
---
```

Example:

```
First idea text
---
Second idea text
```

The 300-character preview is only visual. The full text is stored.

## Project structure

- `app.py` - Python entrypoint and storage logic
- `web/index.html` - UI markup
- `web/style.css` - UI styles
- `web/app.js` - UI logic
- `data/ideas.txt` - local data file

## License

TBD
