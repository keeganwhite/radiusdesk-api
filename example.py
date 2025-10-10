"""
Example usage of the RadiusDesk API client.

This example demonstrates basic operations with the RadiusDesk API.

Note: The /cake4/rd_cake path is automatically added to the base URL
if not already present, so you can use either:
  - https://radiusdesk.example.com
  - https://radiusdesk.example.com/cake4/rd_cake
"""

from radiusdesk_api import RadiusDeskClient

# Initialize the client
# The /cake4/rd_cake path is added automatically if not present
client = RadiusDeskClient(
    base_url="https://radiusdesk.example.com",
    username="admin",
    password="your-password",
    cloud_id="1"
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
    realm_id=1,
    profile_id=2,
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
import time
username = f"test_user_{int(time.time())}"
user = client.users.create(
    username=username,
    password="securepassword123",
    realm_id=1,
    profile_id=2,
    name="Test",
    surname="User",
    email="test@example.com"
)
print(f"Created user: {username}")

# List users
print("\n--- Listing users ---")
users = client.users.list(limit=5)
print(f"Total users: {users.get('totalCount', 'N/A')}")
if 'items' in users:
    for u in users['items'][:5]:
        print(f"  - {u.get('username', 'N/A')}")

print("\n All operations completed successfully!")

