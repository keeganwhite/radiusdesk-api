# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 16-10-2025

### Added

#### Core Features

- **Voucher deletion**: Added `client.vouchers.delete(voucher_id)` method to delete vouchers
- **User deletion**: Fixed and properly implemented `client.users.delete(user_id)` method
  - Now uses correct API format with JSON payload `[{"id": user_id}]`
  - Query parameters moved to URL (token and cloud_id)
  - Proper Content-Type header: `application/json`

#### Error Handling

- **Improved error responses**: All operations now properly check for `success: false` in API responses
- **Better status codes**: Operations that fail validation now return 422 (Unprocessable Entity) instead of 200
- **Detailed error messages**: Error responses include full validation error details from the API
- **Proper exception raising**: Try-catch blocks now work correctly for all operations

#### Testing Infrastructure

- **Automatic test cleanup**: Added `cleanup_users` and `cleanup_vouchers` fixtures
  - All test-created users are automatically deleted after tests complete
  - All test-created vouchers are automatically deleted after tests complete
  - Cleanup works even if tests fail (using pytest's yield mechanism)
- **New tests added**:
  - `test_delete_permanent_user()` - Tests user deletion
  - `test_delete_voucher()` - Tests voucher deletion

#### Development Tools

- **Version management script** (`bump_version.py`):
  - Automatic version bumping: `--patch`, `--minor`, `--major`
  - Updates both `pyproject.toml` and `setup.cfg` automatically
  - Interactive confirmation before changes
- **Makefile** with common development tasks:
  - `make help` - Show all available commands
  - `make test` - Run test suite
  - `make lint` - Check code style
  - `make build` - Build package
  - `make test-build` - Build, validate, and test package locally
  - `make clean` - Remove build artifacts
  - `make release` - Interactive release checklist

#### Documentation

- **CHANGELOG.md** - This file!
- **RELEASE.md** - Detailed release process and local testing guide
- **ERROR_HANDLING_EXAMPLE.md** - Comprehensive error handling documentation
- **tests/README.md** - Test suite documentation with cleanup explanation
- Updated **QUICKSTART.md** with delete examples
- Updated **README.md** with delete examples and new return formats

### Changed

#### Breaking Changes

- **`vouchers.create()` return format**:

  - **Before**: Returned voucher code as string for single vouchers
  - **After**: Returns voucher data as dict with `id`, `name`, etc.
  - For multiple vouchers: Returns list of dicts instead of wrapped response
  - **Migration**: Change `voucher_code = client.vouchers.create(...)` to `voucher = client.vouchers.create(...); voucher_code = voucher['name']`

- **`users.create()` return format**:
  - **Before**: Returned full response with `{'success': True, 'data': {...}}`
  - **After**: Returns just the user data dict
  - **Migration**: Change `user_id = user.get('data', {}).get('id')` to `user_id = user.get('id')`

#### Improvements

- **Consistent error handling**: All create/delete operations now have identical error handling patterns
- **Better logging**: Response data logged at debug level instead of info level
- **Cleaner API**: Direct access to data without navigating nested response structures
- **Type hints**: Updated return type hints to reflect new formats

### Fixed

- **User deletion**: Fixed API call format to match RadiusDesk API requirements
  - Payload is now JSON array instead of form data
  - Token and cloud_id in query params instead of payload
- **Linting**: Removed all trailing whitespace (22 instances)
- **Test reliability**: Tests no longer leave orphaned users/vouchers on server

### Developer Experience

- Local package testing now automated with `make test-build`
- Version updates simplified with `bump_version.py`
- Release process streamlined with documentation and tools
- All code passes flake8 linting with 0 errors

## [0.1.0] - 10-10-2025

### Added

- Initial release
- Basic voucher management:
  - Create vouchers
  - List vouchers
  - Get voucher details
- Basic user management:
  - Create permanent users
  - List permanent users
  - Add data top-ups
  - Add time top-ups
- Authentication support
- GitHub Actions CI/CD pipeline
- Comprehensive test suite
- Documentation (README, QUICKSTART, TESTING)

[0.2.0]: https://github.com/keeganwhite/radiusdesk-api/releases/tag/0.2.0
[0.1.0]: https://github.com/keeganwhite/radiusdesk-api/releases/tag/0.1.0
