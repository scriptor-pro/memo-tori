# Memo Tori Test Suite

This directory contains the automated test suite for Memo Tori.

## Overview

The test suite provides comprehensive coverage of:
- **i18n module** - Internationalization and language detection
- **Storage functions** - Data loading, saving, and persistence
- **API class** - All public API methods and edge cases

## Test Files

| File | Description | Test Count |
|------|-------------|------------|
| `test_i18n.py` | i18n module tests | ~40 tests |
| `test_storage.py` | Storage functions tests | ~30 tests |
| `test_api.py` | Api class tests | ~40 tests |

**Total: ~110 tests**

## Running Tests

### Prerequisites

Install development dependencies:

```bash
pip install -r requirements-dev.txt
```

### Run All Tests

```bash
pytest
```

### Run with Coverage Report

```bash
pytest --cov=. --cov-report=term-missing
```

### Run Specific Test File

```bash
# Test only i18n module
pytest tests/test_i18n.py

# Test only storage functions
pytest tests/test_storage.py

# Test only API class
pytest tests/test_api.py
```

### Run Specific Test Class

```bash
pytest tests/test_i18n.py::TestDetectLanguage
```

### Run Specific Test

```bash
pytest tests/test_api.py::TestApiSaveIdea::test_save_idea_success
```

### Verbose Output

```bash
pytest -v
```

### Show Print Statements

```bash
pytest -s
```

### Run Tests in Parallel (faster)

```bash
pip install pytest-xdist
pytest -n auto
```

## Coverage Reports

### Terminal Report

```bash
pytest --cov=. --cov-report=term-missing
```

### HTML Report

```bash
pytest --cov=. --cov-report=html
# Open htmlcov/index.html in your browser
```

### Generate Both

```bash
pytest --cov=. --cov-report=term-missing --cov-report=html
```

## Coverage Goals

- **Target**: 80%+ overall coverage
- **Critical modules**: 90%+ coverage
  - `i18n.py`
  - Storage functions in `memo-tori.py`
  - `Api` class in `memo-tori.py`

## Test Organization

### Unit Tests

Each module has focused unit tests:
- **test_i18n.py**: Tests language detection, translation loading, and formatting
- **test_storage.py**: Tests file I/O operations and data persistence
- **test_api.py**: Tests API methods and validation logic

### Test Classes

Tests are organized into classes by functionality:
- `TestDetectLanguage` - Language detection logic
- `TestGetTranslations` - Translation retrieval
- `TestTranslate` - Translation formatting
- `TestLoadIdeas` - Loading ideas from disk
- `TestSaveIdeas` - Saving ideas to disk
- `TestApiSaveIdea` - API save method
- `TestApiDeleteIdea` - API delete method
- etc.

### Test Naming Convention

```python
def test_<what_is_being_tested>_<expected_behavior>():
    """Should <expected behavior in plain English>"""
```

Example:
```python
def test_save_idea_rejects_empty_string():
    """Should reject empty string"""
```

## Writing New Tests

### Basic Test Template

```python
def test_my_new_test(tmp_path, monkeypatch):
    """Should do something specific"""
    # Arrange - Set up test data
    data_dir = tmp_path / "data"
    monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
    
    # Act - Perform the action
    result = some_function()
    
    # Assert - Verify the result
    assert result == expected_value
```

### Common Fixtures

- `tmp_path` - Temporary directory for file operations
- `monkeypatch` - Mock environment variables and attributes
- `capsys` - Capture stdout/stderr

### Mocking Environment Variables

```python
def test_with_env_var(monkeypatch):
    monkeypatch.setenv("MEMO_TORI_LANG", "fr")
    # Test code here
```

### Mocking File Paths

```python
def test_with_temp_files(tmp_path, monkeypatch):
    data_dir = tmp_path / "data"
    data_file = data_dir / "ideas.txt"
    monkeypatch.setattr(memo_tori, "DATA_DIR", data_dir)
    monkeypatch.setattr(memo_tori, "DATA_FILE", data_file)
```

## Continuous Integration

Tests should be run automatically on:
- Every commit (pre-commit hook)
- Every pull request
- Before every release

### Add to CI/CD

```yaml
# Example GitHub Actions workflow
- name: Run tests
  run: |
    pip install -r requirements.txt
    pip install -r requirements-dev.txt
    pytest --cov=. --cov-report=term-missing
```

## Test Coverage Analysis

### View Current Coverage

```bash
pytest --cov=. --cov-report=term-missing
```

Look for:
- Overall coverage percentage
- Lines missing coverage
- Functions/branches not tested

### Improve Coverage

1. Identify untested code: `pytest --cov=. --cov-report=term-missing`
2. Review missing lines in the report
3. Add tests for uncovered code paths
4. Re-run tests to verify improvement

## Debugging Tests

### Run with PDB on Failure

```bash
pytest --pdb
```

### Run Last Failed Tests Only

```bash
pytest --lf
```

### Run Failed Tests First

```bash
pytest --ff
```

### Show Detailed Failure Info

```bash
pytest --tb=long
```

## Best Practices

1. **One assertion focus per test** - Tests should verify one specific behavior
2. **Clear test names** - Name describes what is being tested
3. **Arrange-Act-Assert** - Structure tests clearly
4. **Use fixtures** - Leverage pytest fixtures for common setup
5. **Test edge cases** - Empty strings, None, boundaries, etc.
6. **Test error paths** - Not just happy paths
7. **Keep tests fast** - Use mocks instead of real I/O when possible
8. **Independent tests** - Tests should not depend on each other

## Common Test Patterns

### Testing File I/O

```python
def test_file_operation(tmp_path, monkeypatch):
    data_file = tmp_path / "test.txt"
    monkeypatch.setattr(module, "DATA_FILE", data_file)
    # Test code
```

### Testing Error Handling

```python
def test_handles_error():
    with pytest.raises(ExpectedError):
        function_that_should_raise()
```

### Testing Multiple Cases

```python
@pytest.mark.parametrize("input,expected", [
    ("en", "English"),
    ("fr", "French"),
])
def test_language_name(input, expected):
    assert get_language_name(input) == expected
```

## Troubleshooting

### Import Errors

If you get import errors, make sure you're running from the project root:
```bash
cd /path/to/memo-tori
pytest
```

### Module Not Found

Install the package in development mode:
```bash
pip install -e .
```

### Tests Pass Locally but Fail in CI

- Check Python version compatibility
- Verify all dependencies are in requirements-dev.txt
- Check for environment-specific assumptions

## Resources

- [Pytest Documentation](https://docs.pytest.org/)
- [Pytest Best Practices](https://docs.pytest.org/en/stable/goodpractices.html)
- [Coverage.py Documentation](https://coverage.readthedocs.io/)

## Contributing

When adding new features:
1. Write tests first (TDD)
2. Ensure tests pass: `pytest`
3. Check coverage: `pytest --cov=. --cov-report=term-missing`
4. Aim for 80%+ coverage on new code
5. Run full test suite before committing

## Quick Reference

```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=. --cov-report=term-missing --cov-report=html

# Run specific file
pytest tests/test_i18n.py

# Run verbose
pytest -v

# Run and show print statements
pytest -s

# Debug on failure
pytest --pdb

# Re-run failed tests
pytest --lf
```
