import requests
from api import cat_gateway_endpoint_url


# Signed document GET
def get(document_id: str):
    document_url = f"{cat_gateway_endpoint_url("api/v1/document")}/{document_id}"
    return requests.get(document_url)


# Signed document PUT
def put(data: str, token: str):
    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/cbor"}
    data = bytes.fromhex(data)
    return requests.put(
        cat_gateway_endpoint_url("api/v1/document"), headers=headers, data=data
    )


# Signed document v1 POST
def v1_post(filter: dict, limit=None, page=None):
    headers = {"Content-Type": "application/json"}
    url = f"{cat_gateway_endpoint_url("api/v1/document")}/index"
    query_params = []
    if limit is not None:
        query_params.append(f"limit={limit}")
    if page is not None:
        query_params.append(f"page={page}")

    if query_params:
        url += "?" + "&".join(query_params)
    return requests.post(url, headers=headers, json=filter)


# Signed document latest POST
def post(filter: dict, limit=None, page=None):
    headers = {"Content-Type": "application/json"}
    # TODO: change to v2 when endpoint would be added
    url = f"{cat_gateway_endpoint_url("api/v1/document")}/index"
    query_params = []
    if limit is not None:
        query_params.append(f"limit={limit}")
    if page is not None:
        query_params.append(f"page={page}")

    if query_params:
        url += "?" + "&".join(query_params)
    return requests.post(url, headers=headers, json=filter)
