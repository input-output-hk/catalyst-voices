import pytest
from api import metrics


def test_metrics_endpoint():
    resp = metrics.metrics()
    assert (
        resp.status_code == 200
    ), f"Assertion failed: Cannot get metrics '{resp.text}'"
