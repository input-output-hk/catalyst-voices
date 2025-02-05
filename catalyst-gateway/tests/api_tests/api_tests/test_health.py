import os

import requests
from loguru import logger
import pytest

from api_tests import (
    cat_gateway_endpoint_url,
    check_is_live,
    check_is_ready,
)
from datetime import datetime, timezone

@pytest.mark.ci
def test_is_live_endpoint():
    print(os.environ["CAT_GATEWAY_URL"])

    resp = requests.get(cat_gateway_endpoint_url("api/health/live"))
    print(resp)
    assert resp.status_code == 204

    check_is_ready()
