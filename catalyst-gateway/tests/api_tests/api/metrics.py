import requests
from api import cat_gateway_endpoint_url


def metrics():
    return requests.get(cat_gateway_endpoint_url("metrics"))
