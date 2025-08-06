import pytest
from utils import health

@pytest.mark.health_endpoint
def test_ready_endpoint_with_event_db_outage():
    health.is_ready() #assertion
