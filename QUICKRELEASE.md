# Quick Release Guide

## TL;DR - Release in 4 Commands

```bash
# 1. Bump version
python bump_version.py --patch  # or --minor or --major

# 2. Test build locally
make test-build

# 3. Commit and push with [release] tag
git add pyproject.toml setup.cfg
git commit -m "Release version 0.1.1 [release]"
git push origin main

# 4. Watch GitHub Actions deploy to PyPI
# Visit: https://github.com/yourusername/radiusdesk-api/actions
```

That's it! GitHub Actions handles the rest. ✨

---

## Step-by-Step

### 1. Update Version

Choose your version bump strategy:

```bash
# Bug fix: 0.1.0 -> 0.1.1
python bump_version.py --patch

# New feature: 0.1.0 -> 0.2.0
python bump_version.py --minor

# Breaking change: 0.1.0 -> 1.0.0
python bump_version.py --major

# Custom version
python bump_version.py 0.3.5
```

### 2. Test Locally (Important!)

```bash
make test-build
```

This automatically:

- ✅ Cleans old builds
- ✅ Builds new package
- ✅ Validates with twine
- ✅ Tests import in fresh environment

### 3. Commit Changes

```bash
git add pyproject.toml setup.cfg
git commit -m "Bump version to X.Y.Z"
```

### 4. Release

**Option A**: Add `[release]` to any commit message

```bash
git commit -m "Release version X.Y.Z [release]"
git push origin main
```

**Option B**: Make an empty release commit

```bash
git commit --allow-empty -m "Release version X.Y.Z [release]"
git push origin main
```

### 5. Verify

Watch the GitHub Actions workflow:

- https://github.com/yourusername/radiusdesk-api/actions

Check PyPI (takes ~2 minutes):

- https://pypi.org/project/radiusdesk-api/

Test installation:

```bash
pip install radiusdesk-api --upgrade
```

---

## Manual Release (Alternative)

If you prefer to skip GitHub Actions:

```bash
# 1. Update version
python bump_version.py --patch

# 2. Test build
make test-build

# 3. Upload to PyPI
twine upload dist/*
# Enter token when prompted
```

---

## Common Workflows

### Bug Fix Release

```bash
python bump_version.py --patch
make test-build
git add pyproject.toml setup.cfg
git commit -m "Fix user deletion bug"
git commit --allow-empty -m "Release version 0.1.1 [release]"
git push origin main
```

### Feature Release

```bash
python bump_version.py --minor
make test-build
git add pyproject.toml setup.cfg
git commit -m "Add voucher deletion feature"
git commit --allow-empty -m "Release version 0.2.0 [release]"
git push origin main
```

### Multiple Changes Before Release

```bash
# Make your changes
git commit -m "Add feature X"
git commit -m "Fix bug Y"
git commit -m "Update docs"

# When ready to release
python bump_version.py --minor
make test-build
git add pyproject.toml setup.cfg
git commit -m "Bump version to 0.2.0"
git commit --allow-empty -m "Release version 0.2.0 [release]"
git push origin main
```

---

## Makefile Quick Reference

```bash
make help          # Show all commands
make test          # Run tests
make lint          # Check code style
make build         # Build package
make test-build    # Build + validate + test locally
make clean         # Clean build artifacts
make release       # Interactive release checklist
```

---

## Troubleshooting

### "File already exists on PyPI"

You can't re-upload the same version. Bump the version and try again.

### Build fails locally

```bash
make clean
make test-build
```

### Import fails after install

```bash
pip uninstall radiusdesk-api
pip install radiusdesk-api --no-cache-dir
```

### GitHub Actions fails

Check the logs at: https://github.com/yourusername/radiusdesk-api/actions

Common issues:

- Missing `PYPI_API_TOKEN` secret
- Test failures (fix tests first!)
- Linting errors (run `make lint`)

---

## See Also

- **Full details**: [RELEASE.md](RELEASE.md)
- **Publishing setup**: [PUBLISHING.md](PUBLISHING.md)
- **Development**: [TESTING.md](TESTING.md)
