import requests
from api_tests import (
    cat_gateway_endpoint_url,
)
from utils.auth import BEARER_TOKEN

URL = cat_gateway_endpoint_url("api/draft/document")

# Signed document GET
def get(document_id: str):
    document_url = f"{URL}/{document_id}"
    headers = {
        "Authorization": f"Bearer {BEARER_TOKEN}"
    }
    return requests.get(document_url, headers=headers)

# Signed document PUT
def put(data: str):
    headers = {
        "Authorization": f"Bearer {BEARER_TOKEN}",
        "Content-Type": "application/cbor"
    }
    data = bytes.fromhex(data)
    return requests.put(URL, headers=headers, data=data)

# Signed document POST
def post(document_url: str, filter: dict):
    headers = {
        "Authorization": f"Bearer {BEARER_TOKEN}",
        "Content-Type": "application/json"
    }
    return requests.post(f"{URL}{document_url}", headers=headers, json=filter)
