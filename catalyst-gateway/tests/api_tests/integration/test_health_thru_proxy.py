from time import sleep
import pytest

from utils import health
from utils.rbac_chain import rbac_chain_factory, Chain
from utils import ProxyHelper

from api.v1 import rbac
from api.v2 import document


@pytest.fixture
def index_db_proxy():
    proxy = ProxyHelper("haproxy", "scylla_node", "scylla1")
    yield proxy


@pytest.fixture
def event_db_proxy():
    proxy = ProxyHelper("haproxy", "event_db", "pg1")
    yield proxy


@pytest.mark.health_with_proxy_endpoint
def test_ready_endpoint_with_event_db_outage(event_db_proxy, rbac_chain_factory):
    # Not registered stake address
    # Cardano test data CIP0019
    # <https://github.com/cardano-foundation/CIPs/blob/master/CIP-0019/README.md>
    stake_address_not_registered = (
        # cspell:disable-next-line
        "stake_test17rphkx6acpnf78fuvxn0mkew3l0fd058hzquvz7w36x4gtcljw6kf"
    )

    health.is_ready()  # assertion
    # Index DB testing
    auth_token = rbac_chain_factory(Chain.Role0).auth_token()
    resp = rbac.get(lookup=stake_address_not_registered, token=auth_token)
    assert resp.status_code == 404, (
        f"Expected not registered stake address: {resp.status_code} - {resp.text}"
    )
    # Event DB testing
    resp = document.post(filter={}, limit=10, page=0)
    assert resp.status_code == 200, (
        f"Expected document index to succeed: {resp.status_code} - {resp.text}"
    )

    # suspend event db comms
    event_db_proxy.disable()
    health.is_ready()  # assertion
    # event-db threshold to start returning 503
    sleep(120)
    resp = document.post(filter={}, limit=10, page=0)
    assert resp.status_code == 503, (
        f"Expected document index to fail: {resp.status_code} - {resp.text}"
    )
    health.is_not_ready(5)  # assertion

    # Index DB testing
    resp = rbac.get(lookup=stake_address_not_registered, token=auth_token)
    assert resp.status_code == 503, (
        f"Expected RBAC lookup to fail: {resp.status_code} - {resp.text}"
    )
    # Event DB testing
    resp = document.post(filter={}, limit=10, page=0)
    assert resp.status_code == 503, (
        f"Expected document index to fail: {resp.status_code} - {resp.text}"
    )

    # resume event db comms
    event_db_proxy.enable()
    # wait for cat-gateway API to recover
    health.is_ready(5)  # assertion

    # Index DB testing
    resp = rbac.get(lookup=stake_address_not_registered, token=auth_token)
    assert resp.status_code == 404, (
        f"Expected not registered stake address: {resp.status_code} - {resp.text}"
    )
    # Event DB testing
    resp = document.post(filter={}, limit=10, page=0)
    assert resp.status_code == 200, (
        f"Expected document index to succeed: {resp.status_code} - {resp.text}"
    )


@pytest.mark.health_with_proxy_endpoint
def test_ready_endpoint_with_index_db_outage(index_db_proxy, rbac_chain_factory):
    # Not registered stake address
    # Cardano test data CIP0019
    # <https://github.com/cardano-foundation/CIPs/blob/master/CIP-0019/README.md>
    stake_address_not_registered = (
        # cspell:disable-next-line
        "stake_test17rphkx6acpnf78fuvxn0mkew3l0fd058hzquvz7w36x4gtcljw6kf"
    )

    health.is_ready()  # assertion
    # Index DB testing
    auth_token = rbac_chain_factory(Chain.Role0).auth_token()
    resp = rbac.get(lookup=stake_address_not_registered, token=auth_token)
    assert resp.status_code == 404, (
        f"Expected not registered stake address: {resp.status_code} - {resp.text}"
    )
    # Event DB testing
    resp = document.post(filter={}, limit=10, page=0)
    assert resp.status_code == 200, (
        f"Expected document index to succeed: {resp.status_code} - {resp.text}"
    )

    # suspend index db comms
    index_db_proxy.disable()
    health.is_ready()  # assertion
    # index-db threshold to start returning 503
    health.is_not_ready(380)  # assertion
    # Event DB testing
    resp = document.post(filter={}, limit=10, page=0)
    assert resp.status_code == 503, (
        f"Expected document index to fail: {resp.status_code} - {resp.text}"
    )
    # Index DB testing
    resp = rbac.get(lookup=stake_address_not_registered, token=auth_token)
    assert resp.status_code == 503, (
        f"Expected RBAC lookup to fail: {resp.status_code} - {resp.text}"
    )

    # resume index db comms
    index_db_proxy.enable()
    # wait for cat-gateway API to recover
    health.is_ready()  # assertion
    # sleep needs to stay until bug is fixed https://github.com/input-output-hk/catalyst-voices/issues/3705
    sleep(20)
    # Index DB testing
    resp = rbac.get(lookup=stake_address_not_registered, token=auth_token)
    assert resp.status_code == 404, (
        f"Expected not registered stake address: {resp.status_code} - {resp.text}"
    )
    # Event DB testing
    resp = document.post(filter={}, limit=10, page=0)
    assert resp.status_code == 200, (
        f"Expected document index to succeed: {resp.status_code} - {resp.text}"
    )
