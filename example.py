"""
Example usage of the RadiusDesk API client.

This example demonstrates basic operations with the RadiusDesk API.

Configuration:
- If a .env file exists, credentials are loaded from it automatically
- Otherwise, you need to update the fallback values below

Note: The /cake4/rd_cake path is automatically added to the base URL
if not already present.
"""

import os
import time
from dotenv import load_dotenv
from radiusdesk_api import RadiusDeskClient

# Load environment variables from .env file if it exists
env_loaded = load_dotenv()

if env_loaded:
    print("Configuration loaded from .env file\n")
else:
    print("No .env file found, using example configuration...")
    print("To use your own instance, create a .env file or edit the values below\n")

# Get configuration from environment or use fallback values
base_url = os.getenv('RADIUSDESK_URL', 'https://radiusdesk.example.com')
username = os.getenv('RADIUSDESK_USERNAME', 'admin')
password = os.getenv('RADIUSDESK_PASSWORD', 'your-password')
cloud_id = os.getenv('RADIUSDESK_CLOUD_ID', '1')
realm_id = int(os.getenv('RADIUSDESK_REALM_ID', '1'))
profile_id = int(os.getenv('RADIUSDESK_PROFILE_ID', '2'))

# Initialize the client
client = RadiusDeskClient(
    base_url=base_url,
    username=username,
    password=password,
    cloud_id=cloud_id
)

# Check connection
if client.check_connection():
    print("Successfully connected to RadiusDesk!")
else:
    print("Connection failed")
    exit(1)

# Create a single voucher
print("\n--- Creating a voucher ---")
voucher = client.vouchers.create(
    realm_id=realm_id,
    profile_id=profile_id,
    quantity=1
)
print(f"Created voucher: {voucher}")

# List vouchers
print("\n--- Listing vouchers ---")
vouchers = client.vouchers.list(limit=5)
print(f"Total vouchers: {vouchers.get('totalCount', 'N/A')}")
if 'items' in vouchers:
    for v in vouchers['items'][:5]:
        print(f"  - {v.get('name', 'N/A')}")

# Get voucher details
print(f"\n--- Getting details for voucher: {voucher} ---")
details = client.vouchers.get_details(voucher)
print(f"Details: {details}")

# Create a permanent user
print("\n--- Creating a permanent user ---")
test_username = f"test_user_{int(time.time())}"
user = client.users.create(
    username=test_username,
    password="securepassword123",
    realm_id=realm_id,
    profile_id=profile_id,
    name="Test",
    surname="User",
    email="test@example.com"
)
print(f"Created user: {test_username}")

# List users
print("\n--- Listing users ---")
users = client.users.list(limit=5)
print(f"Total users: {users.get('totalCount', 'N/A')}")
if 'items' in users:
    for u in users['items'][:5]:
        print(f"  - {u.get('username', 'N/A')}")

print("\n All operations completed successfully!")
