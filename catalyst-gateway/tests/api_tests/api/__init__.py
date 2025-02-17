import os
import sys

try:
   os.environ["CAT_GATEWAY_TEST_URL"]
except KeyError:
   print ("Please set the environment variable CAT_GATEWAY_TEST_URL")
   sys.exit(1)

try:
   os.environ["BEARER_TOKEN"]
except KeyError:
   print ("Please set the environment variable BEARER_TOKEN")
   sys.exit(1)
   

BEARER_TOKEN = os.environ["BEARER_TOKEN"]
CAT_GATEWAY_TEST_URL = os.environ["CAT_GATEWAY_TEST_URL"]

def cat_gateway_endpoint_url(endpoint: str):
    return f"{CAT_GATEWAY_TEST_URL}/{endpoint}"