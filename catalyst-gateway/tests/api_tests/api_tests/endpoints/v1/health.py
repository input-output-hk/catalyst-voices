import requests
from api_tests import cat_gateway_endpoint_url
LIVE_URL = "api/v1/health/live"
READY_URL = "api/v1/health/ready"

def live():
    return requests.get(cat_gateway_endpoint_url(LIVE_URL))

def ready():
    return requests.get(cat_gateway_endpoint_url(READY_URL))