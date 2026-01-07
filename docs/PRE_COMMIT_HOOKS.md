# Pre-Commit Hooks Guide

This guide explains how to use pre-commit hooks in Memo Tori to automatically run tests before committing code.

## What Are Pre-Commit Hooks?

Pre-commit hooks are scripts that run **automatically before each commit**. They help you:

- ✅ Catch bugs before they enter the codebase
- ✅ Ensure tests always pass
- ✅ Maintain code quality
- ✅ Save time in code review

## Quick Setup

### Install the Hook

```bash
bash scripts/install-pre-commit-hook.sh
```

That's it! The hook is now active.

## How It Works

### Normal Workflow (Tests Pass)

```bash
$ git add .
$ git commit -m "Add new feature"

🧪 Running tests before commit...
──────────────────────────────────
.......................................... [100%]

✅ All tests passed! Proceeding with commit...

[main b3977c3] Add new feature
 1 file changed, 10 insertions(+)
```

### When Tests Fail

```bash
$ git commit -m "Add feature"

🧪 Running tests before commit...
──────────────────────────────────
F......................................... [ 98%]

❌ Tests failed! Commit aborted.

Please fix the failing tests and try again.

💡 Tips:
  - Run 'pytest -v' to see detailed test output
  - Run 'pytest --lf' to re-run only failed tests
  - Use 'git commit --no-verify' to skip this check (not recommended)
```

Your commit is **blocked** until you fix the tests!

## What Gets Checked

The pre-commit hook runs:

```bash
pytest --quiet --tb=line
```

This runs all 82 tests in your test suite (typically takes < 1 second).

## Bypassing the Hook

### Emergency Bypass

If you absolutely need to commit without running tests (not recommended):

```bash
git commit --no-verify -m "Emergency fix"
```

**⚠️ Warning**: Only use this in emergencies! You risk committing broken code.

### When to Bypass

Valid reasons to use `--no-verify`:
- Emergency hotfix that will be tested immediately after
- Work-in-progress commit on a feature branch
- Committing test fixtures or documentation only

**Never bypass on main/master branch!**

## Troubleshooting

### "pytest not found"

**Problem**: The hook can't find pytest.

**Solution**: Install test dependencies:
```bash
pip install -r requirements-dev.txt
```

### Tests are slow

**Problem**: Tests take too long to run on every commit.

**Solution**: The full test suite runs in < 1 second, which is acceptable. If it becomes slower, we can optimize:

1. Run only fast tests in pre-commit
2. Run slower tests in CI/CD
3. Use `pytest -x` to stop at first failure

### Hook not running

**Problem**: You commit but don't see the test output.

**Solution**: 
1. Check if hook exists: `ls -la .git/hooks/pre-commit`
2. Check if it's executable: `chmod +x .git/hooks/pre-commit`
3. Re-run install script: `bash scripts/install-pre-commit-hook.sh`

### Hook runs but uses wrong Python

**Problem**: Hook can't find your virtual environment.

**Solution**: The hook automatically detects:
1. `.venv/` (production venv)
2. `.venv-test/` (test venv)
3. System pytest (fallback)

Make sure one of these exists and has pytest installed.

## Uninstalling the Hook

If you want to remove the pre-commit hook:

```bash
rm .git/hooks/pre-commit
```

To reinstall later:

```bash
bash scripts/install-pre-commit-hook.sh
```

## Team Setup

### For New Team Members

When cloning the repository, run:

```bash
git clone <repository>
cd memo-tori
pip install -r requirements-dev.txt
bash scripts/install-pre-commit-hook.sh
```

The hook is now active for that clone.

### Important Notes

- Git hooks are **not** stored in the repository
- Each person must run the install script
- Add this to your onboarding documentation

## Advanced: Customizing the Hook

The hook file is located at `.git/hooks/pre-commit`. You can edit it to:

### Add More Checks

```bash
# Example: Check code formatting
if ! black --check .; then
    echo "❌ Code formatting issues found"
    echo "Run: black ."
    exit 1
fi
```

### Skip Tests for Certain Files

```bash
# Example: Skip tests if only docs changed
CHANGED_FILES=$(git diff --cached --name-only)
if echo "$CHANGED_FILES" | grep -qv "\.md$"; then
    # Run tests only if non-markdown files changed
    pytest --quiet --tb=line
fi
```

### Add Linting

```bash
# Example: Run flake8
if ! flake8 *.py; then
    echo "❌ Linting errors found"
    exit 1
fi
```

## Best Practices

### Do's ✅

- ✅ Keep tests fast (< 5 seconds ideal)
- ✅ Fix failing tests immediately
- ✅ Run `pytest` manually before committing large changes
- ✅ Share the install script with team members

### Don'ts ❌

- ❌ Don't bypass hooks regularly
- ❌ Don't commit with failing tests
- ❌ Don't disable the hook permanently
- ❌ Don't add slow checks to pre-commit (use CI instead)

## Integration with CI/CD

Pre-commit hooks are your **first line of defense**. They complement CI/CD:

```
Local Development
    ↓
Pre-Commit Hook (tests run locally)
    ↓
git push
    ↓
CI/CD (tests run in cloud)
    ↓
Code Review
    ↓
Merge to main
```

**Both are important!**
- Pre-commit: Fast feedback (< 1 sec)
- CI/CD: Comprehensive checks, multiple environments

## FAQ

**Q: Will this slow down my commits?**  
A: Slightly (< 1 second), but it saves hours of debugging later!

**Q: What if I'm committing documentation only?**  
A: Tests still run (they're fast!), or use `--no-verify` if needed.

**Q: Can I run tests manually instead?**  
A: Yes, but you might forget. Automation prevents mistakes.

**Q: Do I need this if I have CI/CD?**  
A: Yes! Pre-commit catches issues **before** you push, saving CI/CD minutes and avoiding broken builds.

**Q: What about commits from git GUI tools?**  
A: Hooks work with all git tools (command line, VS Code, GitKraken, etc.)

## Summary

```bash
# Install once
bash scripts/install-pre-commit-hook.sh

# Commit normally
git commit -m "Your message"

# Tests run automatically!
# ✅ Pass → commit proceeds
# ❌ Fail → commit blocked, fix tests first
```

**Your code quality just got automated! 🎉**

## Additional Resources

- [Git Hooks Documentation](https://git-scm.com/docs/githooks)
- [Testing Guide](../TESTING.md)
- [Main Documentation](../README.md)
