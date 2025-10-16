# Release Guide

## Versioning

This project uses [Semantic Versioning](https://semver.org/):

- **MAJOR.MINOR.PATCH** (e.g., `0.1.0`)
- **MAJOR**: Breaking changes
- **MINOR**: New features (backwards compatible)
- **PATCH**: Bug fixes (backwards compatible)

### Version Locations

The version must be updated in **TWO** places:

1. **`pyproject.toml`** (line 7):

   ```toml
   version = "0.1.0"
   ```

2. **`setup.cfg`** (line 3):
   ```ini
   version = 0.1.0
   ```

## Testing Locally Before Release

### 1. Clean Previous Builds

```bash
# Remove old build artifacts
rm -rf dist/ build/ *.egg-info/
```

### 2. Build the Package

```bash
# Install build tools (one time)
pip install build twine

# Build the package
python -m build
```

This creates files in the `dist/` directory:

- `radiusdesk_api-X.Y.Z-py3-none-any.whl` (wheel)
- `radiusdesk_api-X.Y.Z.tar.gz` (source distribution)

### 3. Check the Package

```bash
# Validate the package metadata and description
twine check dist/*
```

**Expected output:**

```
Checking dist/radiusdesk_api-0.1.0-py3-none-any.whl: PASSED
Checking dist/radiusdesk_api-0.1.0.tar.gz: PASSED
```

### 4. Test Install Locally

```bash
# Create a test virtual environment
python -m venv test_env
source test_env/bin/activate  # On Windows: test_env\Scripts\activate

# Install from the built wheel
pip install dist/radiusdesk_api-*.whl

# Test it works
python -c "from radiusdesk_api import RadiusDeskClient; print('Import successful!')"

# Or test interactively
python
>>> from radiusdesk_api import RadiusDeskClient
>>> client = RadiusDeskClient(
...     base_url="https://example.com",
...     username="admin",
...     password="pass",
...     cloud_id="1",
...     auto_login=False
... )
>>> print("Works!")
>>> exit()

# Clean up test environment
deactivate
rm -rf test_env/
```

### 5. Test in a Separate Project (Recommended)

Create a new directory and test the package as a user would:

```bash
# In a different directory
mkdir /tmp/test-radiusdesk
cd /tmp/test-radiusdesk
python -m venv venv
source venv/bin/activate

# Install your local build
pip install /path/to/radiusdesk-api/dist/radiusdesk_api-*.whl

# Create a test script
cat > test.py << 'EOF'
from radiusdesk_api import RadiusDeskClient

client = RadiusDeskClient(
    base_url="https://example.com",
    username="admin",
    password="pass",
    cloud_id="1",
    auto_login=False
)

print(f"Client created successfully!")
print(f"Base URL: {client.base_url}")
EOF

python test.py

# Clean up
deactivate
cd -
rm -rf /tmp/test-radiusdesk
```

## Publishing to PyPI

### Prerequisites

1. **Update Version Numbers** in both `pyproject.toml` and `setup.cfg`
2. **Test Locally** (see above)
3. **Commit Changes**:
   ```bash
   git add pyproject.toml setup.cfg
   git commit -m "Bump version to X.Y.Z"
   ```

### Automatic Release (via GitHub Actions)

Push with `[release]` in the commit message:

```bash
# Option 1: Separate release commit
git commit -m "Release version 0.2.0 [release]"
git push origin main

# Option 2: Tag after other commits
git commit -m "Fix user deletion bug"
git commit -m "Add voucher deletion [release]"
git push origin main
```

**GitHub Actions will automatically:**

1. ✅ Lint the code
2. ✅ Run tests
3. ✅ Build the package
4. ✅ Publish to PyPI

### Manual Release (Alternative)

If you prefer to publish manually:

```bash
# Build the package
python -m build

# Upload to PyPI
twine upload dist/*
# Enter your PyPI token when prompted
```

## Release Checklist

Before releasing, ensure:

- [ ] Version updated in `pyproject.toml`
- [ ] Version updated in `setup.cfg`
- [ ] All tests passing: `pytest tests/`
- [ ] Linting passes: `flake8 radiusdesk_api tests`
- [ ] Package builds: `python -m build`
- [ ] Package validates: `twine check dist/*`
- [ ] Tested locally in clean environment
- [ ] CHANGELOG.md updated (if exists)
- [ ] Documentation updated for new features
- [ ] Git tag created: `git tag v0.2.0`

## Quick Commands Reference

```bash
# Clean build
make clean-build  # or: rm -rf dist/ build/ *.egg-info/

# Build and test locally
make test-build   # or see commands above

# Full release process
make release      # or see commands above
```

## Version History

- **0.1.0** - Initial release
  - Basic voucher and user management
  - Authentication support
  - Top-up functionality

## Common Issues

### Issue: "File already exists on PyPI"

**Cause:** You're trying to upload a version that already exists.

**Solution:** Increment the version number. PyPI doesn't allow re-uploading the same version.

### Issue: Build includes old files

**Cause:** Cached build artifacts.

**Solution:**

```bash
rm -rf dist/ build/ *.egg-info/
python -m build
```

### Issue: Import fails after local install

**Cause:** Package not installed correctly or conflicting versions.

**Solution:**

```bash
pip uninstall radiusdesk-api
pip install dist/radiusdesk_api-*.whl --force-reinstall
```
