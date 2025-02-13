import sys
from loguru import logger
import os

try:
   os.environ["CAT_GATEWAY_TEST_URL"]
except KeyError:
   print ("Please set the environment variable CAT_GATEWAY_TEST_URL")
   sys.exit(1)

try:
   os.environ["EVENT_DB_TEST_URL"]
except KeyError:
   print("Please set the environment variable EVENT_DB_TEST_URL")
   sys.exit(1)

EVENT_DB_TEST_URL = os.environ["EVENT_DB_TEST_URL"]
CAT_GATEWAY_TEST_URL = os.environ["CAT_GATEWAY_TEST_URL"]

def cat_gateway_endpoint_url(endpoint: str):
    return f"{CAT_GATEWAY_TEST_URL}/{endpoint}"
