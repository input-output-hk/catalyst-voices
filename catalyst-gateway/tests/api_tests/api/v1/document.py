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
def post(filter: dict, limit=None, page=None):
    headers = {"Content-Type": "application/json"}
    url = f"{URL}/index"
    query_params = []
    if limit is not None:
        query_params.append(f"limit={limit}")
    if page is not None:
        query_params.append(f"page={page}")

    if query_params:
        url += "?" + "&".join(query_params)
    return requests.post(url, headers=headers, json=filter)
