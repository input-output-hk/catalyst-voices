import pytest
from utils import health

@pytest.mark.health_endpoint
def test_live_endpoint():
    health.is_ready() #assertion
