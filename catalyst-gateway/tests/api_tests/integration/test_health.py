import pytest
import time

from api.v1 import rbac
from api.v2 import document
from utils import health
from utils.rbac_chain import rbac_chain_factory, Chain
from wrappers import TestProxy

@pytest.fixture
def index_db_proxy():
    proxy = TestProxy("haproxy", "scylla_node", "scylla1")
    yield proxy

@pytest.fixture
def event_db_proxy():
    proxy = TestProxy("haproxy", "event_db", "pg1")
    yield proxy

@pytest.mark.health_endpoint
@pytest.mark.skip(reason="Bug https://github.com/input-output-hk/catalyst-voices/issues/3209")
def test_ready_endpoint_with_event_db_outage(event_db_proxy, rbac_chain_factory):
    # Not registered stake address
    # Cardano test data CIP0019
    # <https://github.com/cardano-foundation/CIPs/blob/master/CIP-0019/README.md>
    # cspell:disable-next-line
    stake_address_not_registered = "stake_test17rphkx6acpnf78fuvxn0mkew3l0fd058hzquvz7w36x4gtcljw6kf"

    health.is_ready() #assertion
    # Index DB testing
    auth_token = rbac_chain_factory(Chain.Role0).auth_token()
    resp = rbac.get(lookup=stake_address_not_registered, token=auth_token)
    assert(resp.status_code == 404), f"Expected not registered stake address: {resp.status_code} - {resp.text}"
    # Event DB testing
    resp = document.post(filter={},limit=10,page=5)
    assert(resp.status_code == 200), f"Expected document index to succeed: {resp.status_code} - {resp.text}"

    # suspend event db comms
    event_db_proxy.disable()
    time.sleep(35) # wait for cat-gateway API to report not ready
    health.is_not_ready() #assertion

    # Index DB testing
    resp = rbac.get(lookup=stake_address_not_registered, token=auth_token)
    assert(resp.status_code == 503), f"Expected RBAC lookup to fail: {resp.status_code} - {resp.text}"
    # Event DB testing
    resp = document.post(filter={},limit=10,page=5)
    assert(resp.status_code == 503), f"Expected document index to fail: {resp.status_code} - {resp.text}"

    # resume event db comms
    event_db_proxy.enable()
    time.sleep(5) # wait for cat-gateway API to recover
    health.is_ready() #assertion

    # Index DB testing
    resp = rbac.get(lookup=stake_address_not_registered, token=auth_token)
    assert(resp.status_code == 404), f"Expected not registered stake address: {resp.status_code} - {resp.text}"
    # Event DB testing
    resp = document.post(filter={},limit=10,page=5)
    assert(resp.status_code == 200), f"Expected document index to succeed: {resp.status_code} - {resp.text}"

@pytest.mark.health_endpoint
@pytest.mark.skip(reason="Bug https://github.com/input-output-hk/catalyst-voices/issues/3209")
def test_ready_endpoint_with_index_db_outage(index_db_proxy, rbac_chain_factory):
    # Not registered stake address
    # Cardano test data CIP0019
    # <https://github.com/cardano-foundation/CIPs/blob/master/CIP-0019/README.md>
    # cspell:disable-next-line
    stake_address_not_registered = "stake_test17rphkx6acpnf78fuvxn0mkew3l0fd058hzquvz7w36x4gtcljw6kf"

    health.is_ready() #assertion
    # Index DB testing
    auth_token = rbac_chain_factory(Chain.Role0).auth_token()
    resp = rbac.get(lookup=stake_address_not_registered, token=auth_token)
    assert(resp.status_code == 404), f"Expected not registered stake address: {resp.status_code} - {resp.text}"
    # Event DB testing
    resp = document.post(filter={},limit=10,page=5)
    assert(resp.status_code == 200), f"Expected document index to succeed: {resp.status_code} - {resp.text}"

    # suspend event db comms
    index_db_proxy.disable()
    time.sleep(35) # wait for cat-gateway API to report not ready
    health.is_not_ready() #assertion

    # Index DB testing
    resp = rbac.get(lookup=stake_address_not_registered, token=auth_token)
    assert(resp.status_code == 503), f"Expected RBAC lookup to fail: {resp.status_code} - {resp.text}"
    # Event DB testing
    resp = document.post(filter={},limit=10,page=5)
    assert(resp.status_code == 503), f"Expected document index to fail: {resp.status_code} - {resp.text}"

    # resume event db comms
    index_db_proxy.enable()
    time.sleep(5) # wait for cat-gateway API to recover
    health.is_ready() #assertion

    # Index DB testing
    resp = rbac.get(lookup=stake_address_not_registered, token=auth_token)
    assert(resp.status_code == 404), f"Expected not registered stake address: {resp.status_code} - {resp.text}"
    # Event DB testing
    resp = document.post(filter={},limit=10,page=5)
    assert(resp.status_code == 200), f"Expected document index to succeed: {resp.status_code} - {resp.text}"
