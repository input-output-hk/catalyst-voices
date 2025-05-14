import requests
from api import cat_gateway_endpoint_url

URL = cat_gateway_endpoint_url("api/v1/document")
INDEX_URL = cat_gateway_endpoint_url("api/v1/document/index")


# Signed document GET
def get(document_id: str):
    document_url = f"{URL}/{document_id}"
    return requests.get(document_url)


# Signed document PUT
def put(data: str, token: str):
    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/cbor"}
    data = bytes.fromhex(data)
    return requests.put(URL, headers=headers, data=data)


# Signed document POST
def post(document_url: str, filter: dict):
    headers = {"Content-Type": "application/json"}
    return requests.post(f"{URL}{document_url}", headers=headers, json=filter)

# Signed document Index POST
def index_post(filter: dict):
    headers = {"Content-Type": "application/json"}
    return requests.post(f"{INDEX_URL}", headers=headers, json=filter)
