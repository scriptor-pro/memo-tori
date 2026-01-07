# Testing Guide for Memo Tori

This document provides a quick guide to testing Memo Tori.

## Quick Start

### Install Test Dependencies

```bash
pip install -r requirements-dev.txt
```

### Run Tests

```bash
pytest
```

### Run Tests with Coverage

```bash
pytest --cov=. --cov-report=term-missing --cov-report=html
```

Open `htmlcov/index.html` to see detailed coverage report.

## Test Suite Overview

The test suite includes **~110 automated tests** covering:

- ✅ **Internationalization (i18n)** - 40 tests
  - Language detection from environment and system locale
  - Translation loading and formatting
  - All supported languages (English, French)
  
- ✅ **Storage Functions** - 30 tests
  - Loading and saving ideas to disk
  - UTF-8 encoding handling
  - Data integrity and round-trip consistency
  
- ✅ **API Class** - 40 tests
  - Saving ideas with validation
  - Listing ideas (newest first)
  - Deleting ideas by index
  - Error handling and edge cases

## Coverage Goals

| Module | Target | Status |
|--------|--------|--------|
| `i18n.py` | 90%+ | 🎯 |
| Storage functions | 90%+ | 🎯 |
| `Api` class | 90%+ | 🎯 |
| Overall | 80%+ | 🎯 |

## Common Commands

```bash
# Run all tests
pytest

# Run specific test file
pytest tests/test_i18n.py

# Run with verbose output
pytest -v

# Run with coverage
pytest --cov=. --cov-report=term-missing

# Generate HTML coverage report
pytest --cov=. --cov-report=html

# Run in parallel (faster)
pip install pytest-xdist
pytest -n auto

# Debug on failure
pytest --pdb

# Re-run only failed tests
pytest --lf
```

## Test Structure

```
tests/
├── __init__.py
├── README.md           # Detailed test documentation
├── test_i18n.py        # Internationalization tests
├── test_storage.py     # Storage function tests
└── test_api.py         # API class tests
```

## Continuous Integration

Tests should be run:
- ✅ Before every commit (pre-commit hook)
- ✅ On every pull request
- ✅ Before every release

## Adding to GitHub Actions

Add this to your `.github/workflows/test.yml`:

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      
      - name: Install dependencies
        run: |
          pip install -r requirements.txt
          pip install -r requirements-dev.txt
      
      - name: Run tests with coverage
        run: |
          pytest --cov=. --cov-report=term-missing --cov-report=xml
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage.xml
```

## Pre-commit Hook

Automatically run tests before every commit:

```bash
bash scripts/install-pre-commit-hook.sh
```

This installs a git hook that:
- ✅ Runs all tests automatically before each commit
- ✅ Blocks commits if tests fail
- ✅ Takes < 1 second to run

**For details**, see [Pre-Commit Hooks Guide](docs/PRE_COMMIT_HOOKS.md)

## Writing New Tests

See `tests/README.md` for detailed guidelines on:
- Test structure and organization
- Naming conventions
- Common patterns and fixtures
- Best practices

## Further Reading

- **Detailed Guide**: See `tests/README.md`
- **Pytest Docs**: https://docs.pytest.org/
- **Coverage Docs**: https://coverage.readthedocs.io/

## Getting Help

If you encounter issues with tests:
1. Check `tests/README.md` for troubleshooting
2. Run `pytest -v` for verbose output
3. Use `pytest --pdb` to debug failing tests
4. Check test output for specific error messages
