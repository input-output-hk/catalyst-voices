import sys
from loguru import logger
import os

try:
   os.environ["EVENT_DB_TEST_URL"]
except KeyError:
   print("Please set the environment variable EVENT_DB_TEST_URL")
   sys.exit(1)

EVENT_DB_TEST_URL = os.environ["EVENT_DB_TEST_URL"]

