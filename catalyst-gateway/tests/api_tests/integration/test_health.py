from api.v1 import document
from typing import Any, Generator
from wrappers import TestProxy
from wrappers.cat_gateway import CatGateway
from utils import health
import pytest
import time

from utils.rbac_chain import rbac_chain_factory, Chain
from api.v1 import rbac

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
def test_ready_endpoint_with_event_db_outage(event_db_proxy, index_db_proxy, cat_gateway_service, rbac_chain_factory):
    cat_gateway_service.start()
    time.sleep(2) # wait for cat-gateway API to start
    health.is_ready() #assertion

    # suspend event db comms
    event_db_proxy.suspend()
    # fetch endpoint that uses event db
    resp = document.index_post({})
    assert(resp.status_code == 503), f"Expected document index to fail: {resp.status_code} - {resp.text}"
    # call ready endpoint, expect 503
    health.is_not_ready() #assertion

    # re-enable event db
    event_db_proxy.resume()
    #Call `ready` endpoint to attempt re-connection that should succeed
    health.is_ready()

    # fetch endpoint that uses event db
    resp = document.index_post({})
    assert(resp.status_code == 200), f"Expected document index to succeed: {resp.status_code} - {resp.text}"

    # Index DB testing
    auth_token = rbac_chain_factory(Chain.Role0).auth_token()

    # Not registered stake address lookup
    # Cardano test data CIP0019
    # <https://github.com/cardano-foundation/CIPs/blob/master/CIP-0019/README.md>
    # cspell:disable-next-line
    stake_address = "stake_test17rphkx6acpnf78fuvxn0mkew3l0fd058hzquvz7w36x4gtcljw6kf"
    resp = rbac.get(lookup=stake_address, token=auth_token)
    assert(resp.status_code == 404), f"Expected not registered stake address: {resp.status_code} - {resp.text}"

    # disable index db
    index_db_proxy.suspend()
    resp = rbac.get(lookup=stake_address, token=auth_token)
    assert(resp.status_code == 503), f"Expected RBAC lookup to fail: {resp.status_code} - {resp.text}"
