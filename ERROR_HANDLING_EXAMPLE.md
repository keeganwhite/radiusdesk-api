# Error Handling in RadiusDesk API

## Understanding `response.raise_for_status()`

### What it Does

`response.raise_for_status()` only raises an exception for **HTTP status code errors** (4xx, 5xx):

- 404 Not Found
- 500 Internal Server Error
- 401 Unauthorized
- etc.

### What it Does NOT Do

It does **NOT** check the response body content. Many APIs (including RadiusDesk) return:

- **HTTP Status**: 200 OK ✓
- **Response Body**: `{"success": false, "errors": {...}}` ✗

## Example: Creating a User with Existing Username

### API Response

```json
{
  "errors": {
    "username": " The username you provided is already taken. Please provide another one."
  },
  "success": false,
  "username": null,
  "message": "Could not create item<br> The username you provided is already taken. Please provide another one.",
  "invalid_username": "test_user@dev"
}
```

**HTTP Status Code from RadiusDesk**: 200 OK  
**Status Code in APIError Exception**: 422 Unprocessable Entity (corrected by the library)

## Complete Error Handling Example

```python
import os
from radiusdesk_api import RadiusDeskClient
from radiusdesk_api.exceptions import APIError, AuthenticationError

# Initialize client
try:
    client = RadiusDeskClient(
        base_url=os.getenv('RADIUSDESK_URL'),
        username=os.getenv('RADIUSDESK_USERNAME'),
        password=os.getenv('RADIUSDESK_PASSWORD'),
        cloud_id=os.getenv('RADIUSDESK_CLOUD_ID')
    )
except AuthenticationError as e:
    print(f"Authentication failed: {e}")
    exit(1)

# Create user with error handling
try:
    user = client.users.create(
        username="john.doe",
        password="secure-password",
        realm_id=1,
        profile_id=2
    )
    print(f"User created successfully!")
    user_id = user.get('id')  # create() returns just the user data

except APIError as e:
    print(f"Failed to create user: {e}")
    print(f"  Status code: {e.status_code}")
    user_id = None

# Delete user with error handling
if user_id:
    try:
        result = client.users.delete(user_id=user_id)
        print(f"✓ User deleted successfully!")
    except APIError as e:
        print(f"✗ Failed to delete user: {e}")
        print(f"  Status code: {e.status_code}")
```

## What Changed in the Code

### In `users.py` - Create Method

```python
response_data = response.json()

# NEW: Check if the operation was successful
if not response_data.get('success', True):
    error_msg = response_data.get('message', 'Unknown error')
    errors = response_data.get('errors', {})
    if errors:
        error_details = ', '.join([f"{k}: {v}" for k, v in errors.items()])
        error_msg = f"{error_msg} - {error_details}"
    logger.error(f"Failed to create permanent user {username}: {error_msg}")
    raise APIError(f"Failed to create permanent user: {error_msg}", status_code=response.status_code)

logger.info(f"Created permanent user: {username}")
return response_data
```

### In `users.py` - Delete Method

Same pattern applied to ensure `success: false` responses raise `APIError`.
