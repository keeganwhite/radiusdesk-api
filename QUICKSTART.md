# RadiusDesk API - Quick Start Guide

Get started with the RadiusDesk API client.

## Installation

```bash
pip install radiusdesk-api
```

## Basic Setup

```python
from radiusdesk_api import RadiusDeskClient

# Initialize the client
client = RadiusDeskClient(
    base_url="https://your-radiusdesk-instance.com",
    username="your-username",
    password="your-password",
    cloud_id="your-cloud-id"
)

# Verify connection
if client.check_connection():
    print("Connected successfully!")
```

## Common Operations

### Create a Voucher

```python
# Create a single voucher
voucher = client.vouchers.create(
    realm_id=1,
    profile_id=2,
    quantity=1
)
print(f"Voucher created: {voucher['name']} (ID: {voucher['id']})")
```

### List Vouchers

```python
# Get all vouchers
result = client.vouchers.list(limit=100)
for voucher in result['items']:
    print(f"Voucher: {voucher['name']}")
```

### Get Voucher Details

```python
# Get detailed usage information about a voucher
voucher_code = voucher['name']
details = client.vouchers.get_details(voucher_code)
print(details)
```

### Delete a Voucher

```python
# Delete a voucher by ID
result = client.vouchers.delete(voucher_id=123)
if result.get('success'):
    print("Voucher deleted successfully!")
```

### Create a Permanent User

```python
# Create a new permanent user
user = client.users.create(
    username="john.doe",
    password="secure-password",
    realm_id=1,
    profile_id=2,
    name="John",
    surname="Doe",
    email="john@example.com"
)
print("User created successfully!")
```

### Add Top-Ups to Users

```python
# Add data balance to a user
client.users.add_data(
    user_id=123,
    amount=2,
    unit="gb",
    comment="Monthly data"
)

# Add time balance
client.users.add_time(
    user_id=123,
    amount=60,
    unit="minutes",
    comment="Bonus time"
)
```

### Delete a Permanent User

```python
# Delete a permanent user by ID
result = client.users.delete(user_id=123)
if result.get('success'):
    print("User deleted successfully!")
```

## Error Handling

```python
from radiusdesk_api import (
    RadiusDeskClient,
    AuthenticationError,
    APIError
)

try:
    client = RadiusDeskClient(
        base_url="https://example.com",
        username="admin",
        password="wrong-password",
        cloud_id="1"
    )
except AuthenticationError as e:
    print(f"Login failed: {e}")

try:
    voucher = client.vouchers.create(realm_id=1, profile_id=2)
except APIError as e:
    print(f"API Error: {e}")
    print(f"Status Code: {e.status_code}")
```

## Need Help?

- [Full Documentation](README.md)
- [Example Script](example.py)
