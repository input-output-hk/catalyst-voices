import requests
from api import cat_gateway_endpoint_url, CAT_GATEWAY_INTERNAL_API_KEY

URL = cat_gateway_endpoint_url("api/v1/config/frontend")


def put(json_config: dict):
    headers = {
        "Content-Type": "application/json",
        "X-API-Key": CAT_GATEWAY_INTERNAL_API_KEY,
    }
    return requests.put(URL, headers=headers, json=json_config)


def get():
    return requests.get(URL)
