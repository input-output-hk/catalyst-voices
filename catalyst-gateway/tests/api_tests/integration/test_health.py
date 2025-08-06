import pytest
import time

from api.v1 import document, rbac
from typing import Any, Generator
from utils import health
from utils.rbac_chain import rbac_chain_factory, Chain
# from wrappers import TestProxy
from wrappers.cat_gateway import CatGateway

# @pytest.fixture
# def event_db_proxy() -> Generator[Any, Any, Any]:
#     proxy = TestProxy("Event DB", 18080, 5432)
#     proxy.start()
#     yield proxy
#     proxy.stop()
#
#
# @pytest.fixture
# def index_db_proxy() -> Generator[Any, Any, Any]:
#     proxy = TestProxy("Index DB", 18090, 9042)
#     proxy.start()
#     yield proxy
#     proxy.stop()
#
# @pytest.fixture
# def cat_gateway_proxy() -> Generator[Any, Any, Any]:
#     proxy = TestProxy("Cat Gateway", 18100, 3030)
#     proxy.start()
#     yield proxy
#     proxy.stop()
#
# @pytest.fixture
# def cat_gateway_service() -> Generator[Any, Any, Any]:
#     cat = CatGateway()
#     yield cat
#     cat.stop()
#     del cat
#     print("dropped cat-gateway")


@pytest.mark.health_endpoint
def test_ready_endpoint_with_event_db_outage():
    pass
