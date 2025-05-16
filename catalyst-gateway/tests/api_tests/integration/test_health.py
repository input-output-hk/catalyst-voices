from api.v1 import document
from typing import Any, Generator
from wrappers import TestProxy
from wrappers.cat_gateway import CatGateway
from utils import health
import pytest
import time

@pytest.fixture
def event_db_proxy() -> Generator[Any, Any, Any]:
    proxy = TestProxy("Event DB", 18080, 5432)
    proxy.start()
    yield proxy
    proxy.stop()


@pytest.fixture
def index_db_proxy() -> Generator[Any, Any, Any]:
    proxy = TestProxy("Index DB", 18090, 9042)
    proxy.start()
    yield proxy
    proxy.stop()

@pytest.fixture
def cat_gateway_service() -> Generator[Any, Any, Any]:
    cat = CatGateway()
    yield cat
    cat.stop()
    del cat
    print("dropped cat-gateway")


@pytest.mark.health_endpoint
def test_live_endpoint_when_starting_cat_gateway(event_db_proxy, index_db_proxy, cat_gateway_service):
    cat_gateway_service.start()
    time.sleep(2) # wait for cat-gateway API to start
    health.is_ready() #assertion

    # suspend event db comms
    event_db_proxy.suspend()
    # fetch endpoint that uses event db
    resp = document.index_post({})

    assert(resp.status_code == 503), f"Expected document index to fail: {resp.status_code} - {resp.text}"
    health.is_not_ready() #assertion

    # re-enable event db
    event_db_proxy.resume()
    health.is_ready() #Call `ready` endpoint to attempt re-connection that should succeed

    # fetch endpoint that uses event db
    resp = document.index_post({})
    assert(resp.status_code == 200), f"Expected document index to succeed: {resp.status_code} - {resp.text}"
