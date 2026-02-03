import os
import sys

try:
    CAT_GATEWAY_TEST_URL = os.environ["CAT_GATEWAY_TEST_URL"]
    print(f"^^^{CAT_GATEWAY_TEST_URL}")
except KeyError:
    print("Please set the environment variable CAT_GATEWAY_TEST_URL")
    sys.exit(1)

try:
    CAT_GATEWAY_INTERNAL_API_KEY = os.environ["CAT_GATEWAY_INTERNAL_API_KEY"]
except KeyError:
    print("Please set the environment variable CAT_GATEWAY_INTERNAL_API_KEY")
    sys.exit(1)


def cat_gateway_endpoint_url(endpoint: str):
    return f"{CAT_GATEWAY_TEST_URL}/{endpoint}"
