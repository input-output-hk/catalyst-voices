import requests
from api import cat_gateway_endpoint_url

URL = cat_gateway_endpoint_url("api/v1/document")

# Signed document GET
def get(document_id: str, token: str):
    document_url = f"{URL}/{document_id}"
    headers = {
        "Authorization": f"Bearer {token}"
    }
    return requests.get(document_url, headers=headers)

# Signed document PUT
def put(data: str, token: str):
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/cbor"
    }
    data = bytes.fromhex(data)
    return requests.put(URL, headers=headers, data=data)

# Signed document POST
def post(document_url: str, filter: dict, token: str):
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    return requests.post(f"{URL}{document_url}", headers=headers, json=filter)
