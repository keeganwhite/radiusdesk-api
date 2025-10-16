.PHONY: help clean clean-build clean-pyc test lint build check install-dev test-build release

help:
	@echo "RadiusDesk API - Development Commands"
	@echo ""
	@echo "Setup:"
	@echo "  install-dev      Install package in development mode with dev dependencies"
	@echo ""
	@echo "Testing:"
	@echo "  test            Run tests with pytest"
	@echo "  lint            Check code style with flake8"
	@echo ""
	@echo "Building:"
	@echo "  clean           Remove all build, test, and Python artifacts"
	@echo "  build           Build source and wheel distributions"
	@echo "  check           Validate package with twine"
	@echo "  test-build      Clean, build, check, and test install locally"
	@echo ""
	@echo "Release:"
	@echo "  release         Full release process (requires version bump)"

clean: clean-build clean-pyc

clean-build:
	@echo "🧹 Cleaning build artifacts..."
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info/
	rm -rf .eggs/
	@echo "✅ Build artifacts cleaned"

clean-pyc:
	@echo "🧹 Cleaning Python cache files..."
	find . -type f -name '*.pyc' -delete
	find . -type d -name '__pycache__' -delete
	find . -type d -name '*.egg-info' -exec rm -rf {} +
	@echo "✅ Python cache cleaned"

install-dev:
	@echo "📦 Installing package in development mode..."
	pip install -e ".[dev]"
	@echo "✅ Development installation complete"

test:
	@echo "🧪 Running tests..."
	pytest tests/ -v
	@echo "✅ Tests complete"

lint:
	@echo "🔍 Linting code..."
	flake8 radiusdesk_api tests --count --select=E9,F63,F7,F82 --show-source --statistics
	flake8 radiusdesk_api tests --count --max-line-length=100 --statistics
	@echo "✅ Linting complete"

build: clean-build
	@echo "🔨 Building package..."
	python -m build
	@echo "✅ Build complete"
	@ls -lh dist/

check:
	@echo "🔍 Checking package..."
	twine check dist/*
	@echo "✅ Package validation complete"

test-build: clean-build build check
	@echo ""
	@echo "🧪 Testing local installation..."
	@echo "Creating test environment..."
	@python -m venv .test_env
	@.test_env/bin/pip install --quiet --upgrade pip
	@.test_env/bin/pip install --quiet dist/*.whl
	@echo "Testing import..."
	@.test_env/bin/python -c "from radiusdesk_api import RadiusDeskClient; print('✅ Import successful!')"
	@.test_env/bin/python -c "from radiusdesk_api import RadiusDeskClient; c = RadiusDeskClient('http://test.com', 'u', 'p', '1', auto_login=False); print('✅ Client creation successful!')"
	@echo "Cleaning up test environment..."
	@rm -rf .test_env
	@echo ""
	@echo "✅ Local build test complete!"
	@echo ""
	@echo "📦 Package ready for release:"
	@ls -lh dist/

release: lint test build check
	@echo ""
	@echo "🚀 Release checklist:"
	@echo ""
	@echo "  [ ] Version updated in pyproject.toml"
	@echo "  [ ] Version updated in setup.cfg"
	@echo "  [ ] CHANGELOG.md updated"
	@echo "  [ ] All changes committed"
	@echo ""
	@read -p "Have you completed all checklist items? (y/N) " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		echo ""; \
		echo "To release, commit and push with [release] in the message:"; \
		echo ""; \
		echo "  git commit -m 'Release version X.Y.Z [release]'"; \
		echo "  git push origin main"; \
		echo ""; \
		echo "Or manually upload to PyPI:"; \
		echo ""; \
		echo "  twine upload dist/*"; \
		echo ""; \
	else \
		echo "Release cancelled. Complete the checklist first."; \
		exit 1; \
	fi

