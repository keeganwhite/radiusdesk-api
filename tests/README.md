# Test Suite Documentation

## Running Tests

### Prerequisites

Set up environment variables in `.env` file:

```bash
RADIUSDESK_URL=https://your-radiusdesk-instance.com
RADIUSDESK_USERNAME=your-username
RADIUSDESK_PASSWORD=your-password
RADIUSDESK_CLOUD_ID=your-cloud-id
RADIUSDESK_PROFILE_ID=your-profile-id
RADIUSDESK_REALM_ID=your-realm-id
```

### Run All Tests

```bash
pytest tests/
```

### Run Specific Test

```bash
pytest tests/test_users.py::test_create_permanent_user -v
```

## Test Cleanup

All tests that create users automatically clean up after themselves using the `cleanup_users` fixture. This ensures:

1. **No Test Pollution**: Created test users are automatically deleted
2. **Clean Server State**: Your RadiusDesk instance stays clean
3. **Reliable Tests**: Each test runs in isolation

### How It Works

The `cleanup_users` fixture:

- Tracks user IDs created during the test
- Automatically deletes them after the test completes
- Works even if the test fails (using pytest's yield mechanism)

Example:

```python
def test_create_permanent_user(client, test_user_config, cleanup_users):
    user = client.users.create(...)

    # Track for cleanup
    user_id = user.get('id')
    if user_id:
        cleanup_users.append(user_id)

    # ... rest of test ...

    # User is automatically deleted after test completes!
```

### Tests with Existing Users

Some tests use existing users on the server (e.g., `test_add_data_topup_to_existing_user`). These tests:

- Don't create new users
- Don't require cleanup
- Test operations on pre-existing data

## Test Coverage

- ✅ User creation (with full and minimal parameters)
- ✅ User listing (with pagination)
- ✅ User deletion
- ✅ Data top-ups (new users and existing users)
- ✅ Time top-ups (new users and existing users)

## CI/CD

Tests run automatically on:

- Every push to the repository
- Every pull request

See `.github/workflows/ci.yml` for CI configuration.
