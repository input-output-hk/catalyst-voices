import os
import sys

try:
   os.environ["CAT_GATEWAY_TEST_URL"]
except KeyError:
   print ("Please set the environment variable CAT_GATEWAY_TEST_URL")
   sys.exit(1)

CAT_GATEWAY_TEST_URL = os.environ["CAT_GATEWAY_TEST_URL"]

def cat_gateway_endpoint_url(endpoint: str):
    return f"{CAT_GATEWAY_TEST_URL}/{endpoint}"